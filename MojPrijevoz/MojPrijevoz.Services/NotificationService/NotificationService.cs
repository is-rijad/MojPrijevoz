using EasyNetQ;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Notifications;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.NotificationService;

public class NotificationService : INotificationService {
    private readonly IBus _bus;
    private readonly AuthorizationService _authorizationService;

    public NotificationService(IBus bus, AuthorizationService authorizationService)
    {
        _bus = bus;
        _authorizationService = authorizationService;
    }  
    public async Task SendEmailAsync(EmailDto email)
    {
        await _bus.PubSub.PublishAsync(email);
    }

    public async Task SubscribeToFcm(SubscribeToFcmRequest request)
    {
        var userId = _authorizationService.GetUserId();
        await _bus.PubSub.PublishAsync(new SubscribeToFcmDto()
        {
            UserId = userId,
            Token = request.Token,
            Platform = request.Platform
        });
    }

    public async Task UnsubscribeFromFcm()
    {
        var userId = _authorizationService.GetUserId();
        await _bus.PubSub.PublishAsync(new UnSubscribeFromFcmDto()
        {
            UserId = userId,
        });
    }

    public async Task SendToUserAsync(SendToUserDto request)
    {
        await _bus.PubSub.PublishAsync(request);
    }
}