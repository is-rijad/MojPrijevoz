using Microsoft.Extensions.Hosting;
using MojPrijevoz.Notifications.Consumer;

namespace MojPrijevoz.Notifications;

public class NotificationsHostedService : IHostedService
{
    private readonly INotificationConsumer _consumer;

    public NotificationsHostedService(INotificationConsumer consumer)
    {
        _consumer = consumer;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
        => await _consumer.StartConsumingAsync();

    public Task StopAsync(CancellationToken cancellationToken)
        => Task.CompletedTask;
}