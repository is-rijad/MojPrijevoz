namespace MojPrijevoz.Notifications.Consumer;

public interface INotificationConsumer
{
    public Task StartConsumingAsync();
}