using EasyNetQ;
using Microsoft.Extensions.Configuration;
using MojPrijevoz.Model.Dtos.Notifications;

namespace MojPrijevoz.Services.NotificationService;

public class NotificationService : INotificationService {
    private readonly IBus _bus;

    public NotificationService(IBus bus)
    {
        _bus = bus;
    }  
    public async Task SendEmailAsync(EmailDto email)
    {
        await _bus.PubSub.PublishAsync(email);
    }
}