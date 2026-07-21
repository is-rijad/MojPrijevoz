using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using MimeKit;
using MojPrijevoz.Model.Dtos.Notifications;
using Scriban;

namespace MojPrijevoz.Notifications.EmailService;

public class EmailService : IEmailService {
    private readonly string _smtpHost;
    private readonly int _smtpPort;
    private readonly string _smtpUser;
    private readonly string _smtpPassword;
    private readonly string _smtpMojPrijevozEmail;

    public EmailService(IConfiguration configuration)
    {
        var smtp = configuration.GetSection("Smtp");

        _smtpHost = smtp["Host"] ?? throw new InvalidOperationException("SMTP__HOST environment variable is not set.");
        _smtpPort = int.TryParse(smtp["Port"], out var port) ? port : throw new InvalidOperationException("SMTP__PORT environment variable is not set or is not a valid integer.");
        _smtpUser = smtp["User"] ?? throw new InvalidOperationException("SMTP__USER environment variable is not set.");
        _smtpPassword = smtp["Password"] ?? throw new InvalidOperationException("SMTP__PASSWORD environment variable is not set.");
        _smtpMojPrijevozEmail = smtp["MojPrijevozEmail"] ??
                                throw new InvalidOperationException("SMTP__MojPrijevozEmail environment variable is not set.");

    }
    public async Task SendEmailAsync(EmailDto email) {
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("Moj Prijevoz", _smtpUser));
        message.To.Add(new MailboxAddress(null, email.To));
        message.Subject = GetSubject(email);

        message.Body = new TextPart("html") { Text = RenderEmailBody(email) };

        using var client = new SmtpClient();
        await client.ConnectAsync(_smtpHost, _smtpPort, SecureSocketOptions.StartTls);
        await client.AuthenticateAsync(_smtpUser, _smtpPassword);
        await client.SendAsync(message);
        Console.WriteLine($"{email.Type} is successfully sent to {email.To}");
        await client.DisconnectAsync(true);
    }

    private string GetSubject(EmailDto email) {
        return email.Subject ?? email.Type switch
        {
            EmailType.WelcomeEmail => "Dobrodošli u Moj Prijevoz!",
            EmailType.BecomeDriverEmail => "Postali ste vozač!",
            EmailType.ResetPasswordEmail => "Reset lozinke!",
            EmailType.PasswordChangedEmail => "Lozinka promijenjena!",
            EmailType.NewFareOfferEmail => "Nova ponuda za vožnju!",
            EmailType.SentFareOfferEmail => "Ponuda za vožnju poslana!",
            EmailType.ReceiptFareOfferEmail => "Račun za vašu vožnju!",
            EmailType.ReviewVisibleEmail => "Administrator je označio Vašu recenziju vidljivom!",
            EmailType.BecomeAdministratorEmail => "Postali ste administrator!",
            EmailType.AdministratorBannedEmail => "Niste više administrator!",
            EmailType.AdministratorPasswordChangedEmail => "Vaša lozinka je promijenjena!",
            EmailType.TransactionPostedEmail => "Transakcija je proknjižena!",
            EmailType.UserRequestChangesEmail => "Administrator je zatražio promjene na Vašem profilu!",
            EmailType.UserVehicleRequestChangesEmail => "Administrator je zatražio promjene na Vašem vozilu!",
            EmailType.UserBannedEmail => "Administrator Vas je banovao!",
            EmailType.RefundSucceededEmail => "Povrat je izvršen!",
            _ => throw new ArgumentOutOfRangeException(nameof(email.Type), $"Undefined email type: {email.Type}")
        };
    }

    private string RenderEmailBody(EmailDto email) {
        email.Data.Add("MojPrijevozEmail", _smtpMojPrijevozEmail);
        var template = Template.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Templates", $"{email.Type.ToString()}.html")));
        var result = template.Render(email.Data);
        return result;
    }
}