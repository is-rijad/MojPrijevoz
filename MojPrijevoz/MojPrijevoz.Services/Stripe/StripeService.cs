using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Responses.Stripe;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FareOffer;
using Stripe;
using System.Data;

namespace MojPrijevoz.Services.Stripe;

public class StripeService : IPaymentService<StripeHandleRequest, StripeHandleResponse> {
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IConfiguration _config;
    private readonly IFareOfferService _fareOfferService;

    public StripeService(MojPrijevozDbContext dbContext,
        IHttpContextAccessor httpContextAccessor,
        IConfiguration config,
        IFareOfferService fareOfferService)
    {
        _dbContext = dbContext;
        _httpContextAccessor = httpContextAccessor;
        _config = config;
        _fareOfferService = fareOfferService;
    }
    public async Task<StripeHandleResponse> Handle([FromBody] StripeHandleRequest request) {
        var fareOfferId = request.FareOfferId;
        var fareOffer = await _dbContext.FareOffers.FindAsync(fareOfferId);
        if (fareOffer == null)
            throw new NotFoundException("Fare offer not found");

        var options = new PaymentIntentCreateOptions
        {
            Amount = (long)(fareOffer.TotalPrice * 100),
            Currency = "bam",
            Metadata = new Dictionary<string, string> { ["fareOfferId"] = fareOfferId.ToString() }
        };

        var service = new PaymentIntentService();
        var intent = await service.CreateAsync(options);

        return new StripeHandleResponse () { ClientSecret = intent.ClientSecret };
    }

    public async Task Webhook() {
        var json = await new StreamReader(_httpContextAccessor.HttpContext!.Request.Body).ReadToEndAsync();
        var webhookSecret = _config["Stripe:WebhookSecret"];

        try {
            var stripeEvent = EventUtility.ConstructEvent(
                json,
                _httpContextAccessor.HttpContext!.Request.Headers["Stripe-Signature"],
                webhookSecret
            );

            if (stripeEvent.Type == "payment_intent.succeeded") {
                var intent = stripeEvent.Data.Object as PaymentIntent;
                var fareOfferId = int.Parse(intent!.Metadata["fareOfferId"]);
                await _fareOfferService.PayOfferAsync(fareOfferId);
            }
        }
        catch (StripeException) {
            throw new BadRequestException("Invalid Stripe webhook");
        }
    }
}