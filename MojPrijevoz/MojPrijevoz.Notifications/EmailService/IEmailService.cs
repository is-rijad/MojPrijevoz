using MojPrijevoz.Model.Dtos.Notifications;

namespace MojPrijevoz.Notifications.EmailService;

public interface IEmailService {
    public Task SendEmailAsync(EmailDto email);
}