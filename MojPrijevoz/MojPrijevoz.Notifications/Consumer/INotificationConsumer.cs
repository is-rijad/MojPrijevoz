using MojPrijevoz.Model.Dtos.Notifications;

namespace MojPrijevoz.Notifications.Consumer;

public interface INotificationConsumer
{
    public Task StartConsumingAsync();
}