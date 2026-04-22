using Mapster;
using MojPrijevoz.Database;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.City;
using MojPrijevoz.Services.DriversDiscount;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.Fare.StateMachine;
using MojPrijevoz.Services.FareData;
using MojPrijevoz.Services.FareOffer;
using MojPrijevoz.Services.FareOffer.StateMachine;
using MojPrijevoz.Services.OpenRoute;
using MojPrijevoz.Services.SearchFare;
using MojPrijevoz.Services.StopPoint;
using MojPrijevoz.Services.User;
using MojPrijevoz.Services.UserVehicle;
using MojPrijevoz.Services.Vehicle;
using MojPrijevoz.WebApi.Filters;
using System.Text.Json.Serialization;

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

builder.Services.AddMapster();
builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();


builder.Services.AddTransient<TokenManager>();
builder.Services.AddTransient<AuthorizationService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddTransient<CityService>();
builder.Services.AddTransient<AdminCityService>();
builder.Services.AddTransient<UserVehicleService>();
builder.Services.AddTransient<VehicleService>();
builder.Services.AddTransient<DriversDiscountService>();
builder.Services.AddTransient<IFareOfferService,FareOfferService>();
builder.Services.AddTransient<IFareService, FareService>();
builder.Services.AddTransient<IFareDataService, FareDataService>();
builder.Services.AddTransient<IStopPointService, StopPointService>();
builder.Services.AddTransient<ISearchFareService, SearchFareService>();
builder.Services.AddTransient<IOpenRouteService, OpenRouteService>();


builder.Services.AddTransient<BaseFareOfferState>();
builder.Services.AddTransient<InitialFareOfferState>(); 
builder.Services.AddTransient<InNegotiationFareOfferState>(); 


builder.Services.AddTransient<BaseFareState>();
builder.Services.AddTransient<InitialFareState>();
builder.Services.AddTransient<InNegotiationFareState>();
builder.Services.AddTransient<AcceptedFareState>();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment()) {
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();