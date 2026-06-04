using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using MojPrijevoz.Model.Dtos.Notifications;
using Scriban;

namespace MojPrijevoz.Notifications.EmailService;

public class EmailService : IEmailService {
    private readonly string _smtpHost;
    private readonly int _smtpPort;
    private readonly string _smtpUser;
    private readonly string _smtpPassword;

    public EmailService()
    {
        _smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? throw new InvalidOperationException("SMTP_HOST environment variable is not set.");
        _smtpPort = int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out var port) ? port : throw new InvalidOperationException("SMTP_PORT environment variable is not set or is not a valid integer.");
        _smtpUser = Environment.GetEnvironmentVariable("SMTP_USER") ?? throw new InvalidOperationException("SMTP_USER environment variable is not set.");
        _smtpPassword = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? throw new InvalidOperationException("SMTP_PASSWORD environment variable is not set.");
    }
    public async Task SendEmailAsync(EmailDto email)
    {
        Console.WriteLine("EMAIL-------------");
        Console.WriteLine(email.To);
        Console.WriteLine(email.Data.Keys);
        Console.WriteLine(email.Data.Values);
        Console.WriteLine(email.Type);
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("Moj Prijevoz", "noreply@mojprijevoz.ba"));
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

    private string GetSubject(EmailDto email)
    {
        return email.Subject ?? email.Type switch
        {
            EmailType.WelcomeEmail => "Dobrodošli u Moj Prijevoz!",
            EmailType.BecomeDriverEmail => "Postali ste vozač!",
            EmailType.ResetPasswordEmail => "Reset lozinke.",
            EmailType.PasswordChangedEmail => "Lozinka promijenjena!",
            EmailType.NewFareOfferEmail => "Nova ponuda za vožnju!",
            EmailType.AcceptFareOfferEmail => "Vaša ponuda za vožnju je prihvaćena!",
            EmailType.ExpiredFareOfferEmail => "Ponuda za vožnju je istekla!",
            EmailType.RejectFareOfferEmail => "Vaša ponuda za vožnju je odbijena!",
            EmailType.SentFareOfferEmail => "Ponuda za vožnju poslana!",
            EmailType.PayedFareOfferEmail => "Ponuda za vožnju plaćena!",
            _ => throw new ArgumentOutOfRangeException(nameof(email.Type), $"Undefined email type: {email.Type}")
        };
    }

    private string RenderEmailBody(EmailDto email)
    {
        email.Data.Add("MojPrijevozEmail", Environment.GetEnvironmentVariable("MOJ_PRIJEVOZ_EMAIL") ?? throw new ArgumentNullException("MOJ_PRIJEVOZ_EMAIL nije postavljen!"));
        var template = Template.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Templates", $"{email.Type.ToString()}.html")));
        var result = template.Render(email.Data);
        return result;
    }
}