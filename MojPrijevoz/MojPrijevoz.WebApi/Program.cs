using EasyNetQ;
using Mapster;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Responses.Stripe;
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
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;
using MojPrijevoz.Services.OpenRoute;
using MojPrijevoz.Services.SearchFare;
using MojPrijevoz.Services.SignalR.Hubs;
using MojPrijevoz.Services.StopPoint;
using MojPrijevoz.Services.Stripe;
using MojPrijevoz.Services.User;
using MojPrijevoz.Services.UserProfile;
using MojPrijevoz.Services.UserVehicle;
using MojPrijevoz.Services.Vehicle;
using MojPrijevoz.WebApi.Filters;
using Stripe;
using System.Text.Json;
using System.Text.Json.Serialization;
using MojPrijevoz.Services.Rating;
using MojPrijevoz.Services.Transactions;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.json").AddUserSecrets<Program>();

// Add services to the container.
builder.Services.ConfigureAuthorization(builder.Configuration);
builder.Services.AddControllers(config =>
{
    config.ConfigureControllerAuthorization();
    config.Filters.Add<ExceptionFilter>();
}).AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c => c.ConfigureSwaggerAuthorization());

var connectionString = builder.Configuration.GetConnectionString("Default")!;
builder.Services.AddDatabaseServices(connectionString);

StripeConfiguration.ApiKey = builder.Configuration["Stripe:SecretKey"];

TypeAdapterConfig.GlobalSettings.Default.IgnoreNullValues(true);
builder.Services.AddMapster();
builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();
builder.Services.AddSignalR(it => it.EnableDetailedErrors = true);
builder.Services.AddMemoryCache();

var rabbitMqSection = builder.Configuration.GetSection("RabbitMQ");
builder.Services.AddEasyNetQ($"host={rabbitMqSection["Host"]};port={rabbitMqSection["Port"]};username={rabbitMqSection["Username"]};password={rabbitMqSection["Password"]}").UseSystemTextJson();

builder.Services.AddScoped<DbSeeder>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<IFileStorageService, LocalFileStorageService>();
builder.Services.AddScoped<AuthorizationService>();
builder.Services.AddScoped<INotificationService, NotificationService>();


builder.Services.AddTransient<TokenManager>();
builder.Services.AddTransient<CityService>();
builder.Services.AddTransient<AdminCityService>();
builder.Services.AddTransient<UserVehicleService>();
builder.Services.AddTransient<VehicleService>();
builder.Services.AddTransient<DriversDiscountService>();
builder.Services.AddTransient<UserProfileService>();
builder.Services.AddTransient<IFareOfferService,FareOfferService>();
builder.Services.AddTransient<IFareService, FareService>();
builder.Services.AddTransient<IFareDataService, FareDataService>();
builder.Services.AddTransient<IStopPointService, StopPointService>();
builder.Services.AddTransient<ISearchFareService, SearchFareService>();
builder.Services.AddTransient<IOpenRouteService, OpenRouteService>();
builder.Services.AddTransient<IOpenRouteService, OpenRouteService>();
builder.Services.AddTransient<ITransactionService, TransactionService>();
builder.Services.AddTransient<IRatingService, RatingService>();
builder.Services.AddTransient<IPaymentService<StripeHandleRequest, StripeHandleResponse>, StripeService>();


builder.Services.AddTransient<BaseFareOfferState>();
builder.Services.AddTransient<InitialFareOfferState>(); 
builder.Services.AddTransient<InNegotiationFareOfferState>(); 
builder.Services.AddTransient<AcceptedFareOfferState>();


builder.Services.AddTransient<BaseFareState>();
builder.Services.AddTransient<InitialFareState>();
builder.Services.AddTransient<InNegotiationFareState>();
builder.Services.AddTransient<AcceptedFareState>();
builder.Services.AddTransient<PayedFareState>();


builder.Services.AddSingleton<ConnectionTracker>();
builder.Services.AddSingleton<PendingLocationRequests>();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment()) {
    app.UseSwagger();
    app.UseSwaggerUI();
}
using var scope = app.Services.CreateScope();
var database = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();
await database.Database.MigrateAsync();

var dbSeeder = scope.ServiceProvider.GetRequiredService<DbSeeder>();
await dbSeeder.SeedAsync();

app.MapHub<FareLocationsHub>("/hubs/fareLocations");
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAuthorization();
app.MapControllers();
app.Run();