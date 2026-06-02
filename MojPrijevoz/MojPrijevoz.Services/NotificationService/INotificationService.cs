using MojPrijevoz.Model.Dtos.Notifications;

namespace MojPrijevoz.Services.NotificationService
{
    public interface INotificationService
    {
        public Task SendEmailAsync(EmailDto email);
    }
}