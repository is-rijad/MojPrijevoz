using EasyNetQ;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Notifications.EmailService;
using MojPrijevoz.Notifications.NotificationService;

namespace MojPrijevoz.Notifications.Consumer;

public class NotificationConsumer : INotificationConsumer
{
    private readonly IBus _bus;
    private readonly IEmailService _emailService;
    private readonly INotificationService _notificationService;

    public NotificationConsumer(IBus bus, IEmailService emailService, INotificationService notificationService)
    {
        _bus = bus;
        _emailService = emailService;
        _notificationService = notificationService;
    }

    public async Task StartConsumingAsync()
    {
        await _bus.PubSub.SubscribeAsync<EmailDto>("email-consumer", async email => await HandleEmailAsync(email));
        await _bus.PubSub.SubscribeAsync<SubscribeToFcmDto>("subscribe-to-fcm-consumer", async request => await HandleSubscribeToFcmAsync(request));
        await _bus.PubSub.SubscribeAsync<UnSubscribeFromFcmDto>("unsubscribe-from-fcm-consumer", async request => await HandleUnSubscribeFromFcmAsync(request));
        await _bus.PubSub.SubscribeAsync<SendToUserDto>("send-to-user-consumer", async request => await HandleSendToUserAsync(request));
    }

    private async Task HandleEmailAsync(EmailDto email)
    {
        await _emailService.SendEmailAsync(email);
    }
    private async Task HandleSubscribeToFcmAsync(SubscribeToFcmDto dto) {
        await _notificationService.SubscribeToFcmAsync(dto);
    }
    private async Task HandleUnSubscribeFromFcmAsync(UnSubscribeFromFcmDto dto) {
        await _notificationService.UnsubscribeFromFcm(dto);
    }
    private async Task HandleSendToUserAsync(SendToUserDto dto) {
        await _notificationService.SendToUserAsync(dto);
    }
}