using EasyNetQ;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MojPrijevoz.Database;
using MojPrijevoz.Notifications;
using MojPrijevoz.Notifications.Consumer;
using MojPrijevoz.Notifications.EmailService;
using MojPrijevoz.Notifications.NotificationService;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
        var connectionString = context.Configuration.GetConnectionString("Default")!;
        services.AddDatabaseServices(connectionString);

        var rabbitMqSection = context.Configuration.GetSection("RabbitMQ");
        services.AddEasyNetQ(
                $"host={rabbitMqSection["Host"]};port={rabbitMqSection["Port"]};username={rabbitMqSection["User"]};password={rabbitMqSection["Password"]}")
            .UseSystemTextJson();

        services.AddSingleton<INotificationConsumer, NotificationConsumer>();
        services.AddSingleton<IEmailService, EmailService>();
        services.AddSingleton<INotificationService, NotificationService>();
        FirebaseApp.Create(new AppOptions
        {
            Credential = CredentialFactory
                .FromFile<ServiceAccountCredential>(context.Configuration["Firebase:CredentialPath"] ??
                                                    throw new ArgumentException("FIREBASE__CREDENTIAL_PATH is not set"))
                .ToGoogleCredential()
        });

        services.AddHostedService<NotificationsHostedService>();
    })
    .Build();

await host.RunAsync();