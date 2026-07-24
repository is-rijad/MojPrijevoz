using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Responses.Stripe;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FareOffer;
using MojPrijevoz.Services.NotificationService;
using Stripe;

namespace MojPrijevoz.Services.Stripe;

public class StripeService : IPaymentService<StripeHandleRequest, StripeHandleResponse>
{
    private readonly IConfiguration _config;
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger _logger;

    private readonly string _cacheKey = "stripe_event_";
    private readonly IMemoryCache _cache;

    public StripeService(MojPrijevozDbContext dbContext,
        IHttpContextAccessor httpContextAccessor,
        IConfiguration config,
        IServiceProvider serviceProvider,
        ILogger logger,
        IMemoryCache cache)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
        _config = config;
        _serviceProvider = serviceProvider;
        _logger = logger;
        _cache = cache;
    }

    public async Task<StripeHandleResponse> Handle([FromBody] StripeHandleRequest request)
    {
        var fareOfferId = request.FareOfferId;
        var fareOffer = await _dbContext.FareOffers.FindAsync(fareOfferId);
        if (fareOffer == null)
            throw new NotFoundException("Fare offer not found");

        var options = new PaymentIntentCreateOptions
        {
            Amount = (long)fareOffer.TotalPrice * 100,
            Currency = "bam",
            Metadata = new Dictionary<string, string> { ["fareOfferId"] = fareOfferId.ToString() },
        };

        var requestOptions = new RequestOptions
        {
            IdempotencyKey = $"fareoffer-payment-intent-{{fareOfferId}}"
        };

        var service = new PaymentIntentService();
        var intent = await service.CreateAsync(options, requestOptions);

        return new StripeHandleResponse { ClientSecret = intent.ClientSecret };
    }

    public async Task Webhook()
    {
        var json = await new StreamReader(_httpContextAccessor.HttpContext!.Request.Body).ReadToEndAsync();
        var webhookSecret = _config["Stripe:WebhookSecret"];

        try
        {
            var stripeEvent = EventUtility.ConstructEvent(
                json,
                _httpContextAccessor.HttpContext!.Request.Headers["Stripe-Signature"],
                webhookSecret,
                throwOnApiVersionMismatch: false
            );

            if (_cache.TryGetValue(_cacheKey + stripeEvent.Id, out var _))
            {
                return;
            }

            if (stripeEvent.Type == "payment_intent.succeeded")
            {
                var intent = stripeEvent.Data.Object as PaymentIntent;
                var fareOfferId = int.Parse(intent!.Metadata["fareOfferId"]);
                await _serviceProvider.GetRequiredService<IFareOfferService>().PayOfferAsync(fareOfferId, intent.Id);
            }
            else if (stripeEvent.Type == "refund.updated")
            {
                var refund = stripeEvent.Data.Object as Refund;
                if (refund!.Status != "succeeded") return;
                var paymentIntendId = refund.PaymentIntentId;
                var transaction = await _dbContext.Transactions.Include(it => it.Fare).ThenInclude(it => it!.Passenger)
                    .ThenInclude(it => it!.User).FirstOrDefaultAsync(it => it.PaymentIntentId == paymentIntendId);
                if (transaction != null)
                {
                    _dbContext.Remove(transaction);
                    await _dbContext.SaveChangesAsync();
                    await _serviceProvider.GetRequiredService<INotificationService>().SendEmailAsync(new EmailDto
                    {
                        To = transaction.Fare!.Passenger!.User!.Email,
                        Type = EmailType.RefundSucceededEmail,
                        Data = new Dictionary<string, dynamic>
                        {
                            ["Name"] = transaction.Fare.Passenger.User.FirstName,
                            ["Amount"] = transaction.Amount + (transaction.FeeAmount ?? 0)
                        }
                    });
                }
            }

            _cache.Set(_cacheKey + stripeEvent.Id, true, TimeSpan.FromHours(24));
        }
        catch (StripeException)
        {
            throw new BadRequestException("Invalid Stripe webhook");
        }
    }

    public async Task CreateRefund(int fareOfferId, string paymentIntentId)
    {
        var options = new RefundCreateOptions
        {
            PaymentIntent = paymentIntentId,
            Metadata = new Dictionary<string, string>
            {
                ["FareOfferId"] = fareOfferId.ToString()
            }
        };

        var service = new RefundService();
        try
        {
            var refund = await service.CreateAsync(options);
        }
        catch (StripeException e)
        {
            _logger.LogError($"Stripe greška - refund: {e.Message}");
        }
    }
}