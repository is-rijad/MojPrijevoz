using EasyNetQ;
using Mapster.Utils;
using MapsterMapper;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Notifications;
using MojPrijevoz.Model.Responses.Notification;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.SignalR.Hubs;

namespace MojPrijevoz.Services.NotificationService;

public class NotificationService : BaseService<NotificationResponse, Notification, NotificationSearchObject>,
    INotificationService
{
    private readonly AuthorizationService _authorizationService;
    private readonly IBus _bus;
    private readonly IHubContext<SignalRHub> _notificationsHubContext;
    private readonly ConnectionTracker _connectionTracker;
    private readonly ILogger _logger;

    public NotificationService(IBus bus, AuthorizationService authorizationService, MojPrijevozDbContext dbContext,
        IMapper mapper, IHubContext<SignalRHub> notificationsHubContext,
        ConnectionTracker connectionTracker,
        ILogger logger) : base(dbContext, mapper)
    {
        _bus = bus;
        _authorizationService = authorizationService;
        _notificationsHubContext = notificationsHubContext;
        _connectionTracker = connectionTracker;
        _logger = logger;
    }

    public async Task SendEmailAsync(EmailDto email)
    {
        await _bus.PubSub.PublishAsync(email);
    }


    public async Task SubscribeToFcm(SubscribeToFcmRequest request)
    {
        var userId = _authorizationService.GetUserId();
        await _bus.PubSub.PublishAsync(new SubscribeToFcmDto
        {
            UserId = userId,
            Token = request.Token,
            Platform = request.Platform
        });
    }

    public async Task UnsubscribeFromFcm()
    {
        var userId = _authorizationService.GetUserId();
        await _bus.PubSub.PublishAsync(new UnSubscribeFromFcmDto
        {
            UserId = userId
        });
    }

    public async Task SendToUserAsync(SendToUserDto request)
    {
        await _bus.PubSub.PublishAsync(request);

        try
        {
            request.Data.TryGetValue("RatingId", out var ratingId);
            var connId = _connectionTracker.Get(request.UserId.ToString());
            if (connId is null)
            {
                throw new Exception("User is not registered");
            }
            await _notificationsHubContext.Clients.Client(connId).SendAsync("NewNotification",
                new Notification
                {
                    CreatedAt = DateTime.UtcNow,
                    FareId = int.Parse(request.Data["FareId"]),
                    Side = Enum<ProfileType>.Parse(request.Data["Side"]),
                    Id = 0,
                    IsRead = false,
                    UserId = request.UserId,
                    Message = request.Body,
                    Type = request.Data["Type"],
                    RatingId = !string.IsNullOrEmpty(ratingId) ? int.Parse(ratingId) : null
                });
            _logger.LogInformation($"Message {request.Data["Type"]} is sent to user {request.UserId} By SignalR");
        }
        catch (Exception)
        {
            _logger.LogError($"Message {request.Data["Type"]} failed to send to user {request.UserId}");
        }
    }

    public async Task SendSilentToUserAsync(SendSilentToUserDto request)
    {
        await _bus.PubSub.PublishAsync(request);
    }

    public async Task<NotificationResponse?> MarkAsReadAsync(int id)
    {
        var notification = await _dbContext.Notifications.FindAsync(id);
        if (notification != null)
        {
            notification.IsRead = true;
            await _dbContext.SaveChangesAsync();
        }

        return notification != null ? MapToResponseModel<NotificationResponse>(notification, _mapper) : null;
    }

    public override async Task<IQueryable<Notification>> ApplyFilter(IQueryable<Notification> queryable,
        NotificationSearchObject searchObject)
    {
        await base.ApplyFilter(queryable, searchObject);
        var userId = _authorizationService.GetUserId();
        queryable = queryable.Where(it => it.UserId == userId);
        return queryable;
    }

    protected override IQueryable<Notification> ApplyOrdering(IQueryable<Notification> queryable,
        NotificationSearchObject searchObject)
    {
        queryable = queryable.OrderByDescending(it => it.CreatedAt).ThenBy(it => it.IsRead);
        return queryable.AsQueryable();
    }
}