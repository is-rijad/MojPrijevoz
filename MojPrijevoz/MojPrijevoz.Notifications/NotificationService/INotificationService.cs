using MojPrijevoz.Model.Dtos.Notifications;

namespace MojPrijevoz.Notifications.NotificationService;

public interface INotificationService {
    public Task SubscribeToFcmAsync(SubscribeToFcmDto dto);
    public Task UnsubscribeFromFcm(UnSubscribeFromFcmDto dto);
    public Task SendToUserAsync(SendToUserDto dto);
    public Task SendSilentToUserAsync(SendSilentToUserDto dto);
}