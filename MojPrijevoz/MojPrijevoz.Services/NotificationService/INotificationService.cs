using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Notifications;
using MojPrijevoz.Model.Responses.Notification;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.NotificationService {
    public interface INotificationService : IBaseService<NotificationResponse, NotificationSearchObject> {
        public Task SendEmailAsync(EmailDto email);
        public Task SubscribeToFcm(SubscribeToFcmRequest request);
        public Task UnsubscribeFromFcm();
        public Task SendToUserAsync(SendToUserDto request);
        public Task SendSilentToUserAsync(SendSilentToUserDto request);
        public Task<NotificationResponse?> MarkAsReadAsync(int id);
    }
}