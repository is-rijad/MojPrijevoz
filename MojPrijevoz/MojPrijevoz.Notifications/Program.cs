using EasyNetQ;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
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
        var connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING") ?? throw new InvalidOperationException("DB_CONNECTION_STRING environment variable is not set.");
        services.AddDatabaseServices(connectionString);

        var rabbitConnString =
            $"host={Environment.GetEnvironmentVariable("RABBITMQ_HOST")};port={Environment.GetEnvironmentVariable("RABBITMQ_PORT")};username={Environment.GetEnvironmentVariable("RABBITMQ_DEFAULT_USER")};password={Environment.GetEnvironmentVariable("RABBITMQ_DEFAULT_PASS")}";
        Console.WriteLine($"RabbitMQ Connection String: {rabbitConnString}");
        services.AddEasyNetQ(rabbitConnString).UseSystemTextJson();

        services.AddSingleton<INotificationConsumer, NotificationConsumer>();
        services.AddSingleton<IEmailService, EmailService>();
        services.AddSingleton<INotificationService, NotificationService>();

        FirebaseApp.Create(new AppOptions
        {
            Credential = CredentialFactory.FromFile<ServiceAccountCredential>(Environment.GetEnvironmentVariable("FIREBASE_CREDENTIALS_PATH") ?? throw new ArgumentException("FIREBASE_CREDENTIALS_PATH is not set")).ToGoogleCredential()
        });

        services.AddHostedService<NotificationsHostedService>();

    })
    .Build();

await host.RunAsync();
