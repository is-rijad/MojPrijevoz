using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Notifications;

namespace MojPrijevoz.Services.NotificationService
{
    public interface INotificationService
    {
        public Task SendEmailAsync(EmailDto email);
        public Task SubscribeToFcm(SubscribeToFcmRequest request);
        public Task UnsubscribeFromFcm();
        public Task SendToUserAsync(SendToUserDto request);
    }
}