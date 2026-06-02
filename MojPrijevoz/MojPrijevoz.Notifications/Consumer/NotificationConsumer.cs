using EasyNetQ;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Notifications.EmailService;

namespace MojPrijevoz.Notifications.Consumer;

public class NotificationConsumer : INotificationConsumer
{
    private readonly IBus _bus;
    private readonly IEmailService _emailService;

    public NotificationConsumer(IBus bus, IEmailService emailService)
    {
        _bus = bus;
        _emailService = emailService;
    }

    public async Task StartConsumingAsync()
    {
        await _bus.PubSub.SubscribeAsync<EmailDto>("email-consumer", async email => await HandleEmailAsync(email));
    }

    private async Task HandleEmailAsync(EmailDto email)
    {
        await _emailService.SendEmailAsync(email);
    }
}