using DotNetEnv;
using EasyNetQ;
using Mapster;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Responses.Stripe;
using MojPrijevoz.Recommender.Configuration;
using MojPrijevoz.Services.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.City;
using MojPrijevoz.Services.DbSeeder;
using MojPrijevoz.Services.DriversDiscount;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.Fare.StateMachine;
using MojPrijevoz.Services.FareData;
using MojPrijevoz.Services.FareOffer;
using MojPrijevoz.Services.FareOffer.StateMachine;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.Helpers;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.Mapster;
using MojPrijevoz.Services.NotificationService;
using MojPrijevoz.Services.OpenRoute;
using MojPrijevoz.Services.Rating;
using MojPrijevoz.Services.SearchFare;
using MojPrijevoz.Services.SignalR.Hubs;
using MojPrijevoz.Services.StopPoint;
using MojPrijevoz.Services.Stripe;
using MojPrijevoz.Services.Transactions;
using MojPrijevoz.Services.User;
using MojPrijevoz.Services.UserProfile;
using MojPrijevoz.Services.UserVehicle;
using MojPrijevoz.Services.Vehicle;
using MojPrijevoz.WebApi.Filters;
using QuestPDF;
using QuestPDF.Infrastructure;
using Stripe;
using System.Globalization;
using System.Text.Json.Serialization;

Env.Load("./.env");

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.json", false);

// Add services to the container.
builder.Services.ConfigureAuthorization(builder.Configuration);
builder.Services.AddControllers(config =>
{
    config.ConfigureControllerAuthorization();
    config.Filters.Add<ExceptionFilter>();
}).AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    options.JsonSerializerOptions.Converters.Add(new JsonDateTimeUtcConverter());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c => c.ConfigureSwaggerAuthorization());

var connectionString = builder.Configuration.GetConnectionString("Default")!;
builder.Services.AddDatabaseServices(connectionString);

StripeConfiguration.ApiKey = builder.Configuration["Stripe:SecretKey"];
Settings.License = LicenseType.Community;

TypeAdapterConfig.GlobalSettings.Default.IgnoreNullValues(true);
TypeAdapterConfig.GlobalSettings.Scan(typeof(Configuration).Assembly);
builder.Services.AddMapster();
builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();
builder.Services.AddSignalR(it => it.EnableDetailedErrors = true);
builder.Services.AddMemoryCache();
builder.Services.AddRecommenderService();
builder.Services.AddHostedService<FareBackgroundService>();

var rabbitMqSection = builder.Configuration.GetSection("RabbitMQ");
builder.Services
    .AddEasyNetQ(
        $"host={rabbitMqSection["Host"]};port={rabbitMqSection["Port"]};username={rabbitMqSection["User"]};password={rabbitMqSection["Password"]}")
    .UseSystemTextJson();

builder.Services.AddScoped<DbSeeder>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<IFileStorageService, LocalFileStorageService>();
builder.Services.AddScoped<AuthorizationService>();
builder.Services.AddScoped<INotificationService, NotificationService>();


builder.Services.AddScoped<TokenManager>();
builder.Services.AddScoped<CityService>();
builder.Services.AddScoped<UserVehicleService>();
builder.Services.AddScoped<VehicleService>();
builder.Services.AddScoped<DriversDiscountService>();
builder.Services.AddScoped<UserProfileService>();
builder.Services.AddScoped<IFareOfferService, FareOfferService>();
builder.Services.AddScoped<IFareService, FareService>();
builder.Services.AddScoped<IFareDataService, FareDataService>();
builder.Services.AddScoped<IStopPointService, StopPointService>();
builder.Services.AddScoped<ISearchFareService, SearchFareService>();
builder.Services.AddScoped<IOpenRouteService, OpenRouteService>();
builder.Services.AddScoped<IOpenRouteService, OpenRouteService>();
builder.Services.AddScoped<ITransactionService, TransactionService>();
builder.Services.AddScoped<IRatingService, RatingService>();
builder.Services.AddScoped<IPaymentService<StripeHandleRequest, StripeHandleResponse>, StripeService>();


builder.Services.AddScoped<BaseFareOfferState>();
builder.Services.AddScoped<InitialFareOfferState>();
builder.Services.AddScoped<InNegotiationFareOfferState>();
builder.Services.AddScoped<AcceptedFareOfferState>();
builder.Services.AddScoped<PayedFareOfferState>();


builder.Services.AddScoped<BaseFareState>();
builder.Services.AddScoped<InitialFareState>();
builder.Services.AddScoped<InNegotiationFareState>();
builder.Services.AddScoped<AcceptedFareState>();
builder.Services.AddScoped<PayedFareState>();
builder.Services.AddScoped<InProgressFareState>();


builder.Services.AddSingleton<ConnectionTracker>();
builder.Services.AddScoped<RevokedTokenService>();


builder.Services.AddScoped<AdminUsersService>();
builder.Services.AddScoped<AdminCityService>();
builder.Services.AddScoped<AdminVehicleService>();
builder.Services.AddScoped<AdminUserVehiclesService>();
builder.Services.AddScoped<AdminRatingService>();
builder.Services.AddScoped<AdminCityService>();
builder.Services.AddScoped<AdminAdministratorService>();
builder.Services.AddScoped<AdminTransactionService>();
builder.Services.AddScoped<AdminStatsService>();
builder.Services.AddScoped<AdminReportService>();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

var supportedCultures = new[] { new CultureInfo("en-US") };
app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("en-US"),
    SupportedCultures = supportedCultures,
    SupportedUICultures = supportedCultures
});

using var scope = app.Services.CreateScope();
var database = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();

var databaseCreator = database.Database.GetService<IRelationalDatabaseCreator>();
if (!await databaseCreator.ExistsAsync()) await databaseCreator.CreateAsync();

await database.Database.MigrateAsync();
var dbSeeder = scope.ServiceProvider.GetRequiredService<DbSeeder>();
await dbSeeder.SeedAsync();

app.MapHub<SignalRHub>("/hubs");
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAuthorization();
app.MapControllers();
app.Run();