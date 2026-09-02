using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.FareLocation;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.SignalR.Hubs;

[Authorize]
public class SignalRHub(
    IMemoryCache cache,
    ConnectionTracker tracker,
    INotificationService notificationService,
    IServiceScopeFactory scopeFactory) : Hub
{
    public static readonly TimeSpan CacheTtl = TimeSpan.FromHours(24);

    public static string GetCacheKey(string userId)
    {
        return $"loc:{userId}";
    }

    private string GetUserId()
    {
        return Context.User?.Claims.FirstOrDefault(it => it.Type == JwtRegisteredClaimNames.Sub)?.Value ??
               throw new NullReferenceException("UserId is not provided!");
    }

    public override Task OnConnectedAsync()
    {
        var userId = GetUserId();
        tracker.Register(userId, Context.ConnectionId);
        return base.OnConnectedAsync();
    }

    public override Task OnDisconnectedAsync(Exception? ex)
    {
        var userId = GetUserId();
        tracker.Remove(userId);
        return base.OnDisconnectedAsync(ex);
    }

    public async Task SendProximityNotification(ProximityNotificationDto dto)
    {
        await notificationService.SendToUserAsync(new SendToUserDto
        {
            UserId = dto.UserId,
            Title = "Vozač je u blizini",
            Body = $"Vozač je na {Math.Round(dto.Distance, 0)}km od Vas",
            Data = new Dictionary<string, string>
            {
                ["Type"] = SendToUserDto.ProximityNotificationType,
                ["FareId"] = dto.FareId.ToString(),
                ["Side"] = ProfileType.Driver.ToString()
            }
        });
    }

    private async Task<int> ValidateFareLocationAccess(int fareId, string callerUserId)
    {
        var callerId = int.Parse(callerUserId);
        await using var scope = scopeFactory.CreateAsyncScope();
        var fareService = scope.ServiceProvider.GetRequiredService<IFareService>();

        Database.Fare fare;
        try
        {
            fare = await fareService.GetFareForLocationAccess(fareId, callerId);
        }
        catch (Exception e) when (e is NotFoundException or ForbiddenException or BadRequestException)
        {
            throw new HubException(e.Message);
        }

        return fare.Driver!.UserId == callerId ? fare.Passenger!.UserId : fare.Driver!.UserId;
    }

    public async Task RequestLocation(int fareId)
    {
        var requesterId = GetUserId();
        var targetUserId = await ValidateFareLocationAccess(fareId, requesterId);
        var connectionId = tracker.Get(targetUserId.ToString());

        if (connectionId != null)
            await Clients.Client(connectionId)
                .SendAsync("LocationRequested", requesterId);
        else
            await notificationService.SendSilentToUserAsync(new SendSilentToUserDto
            {
                UserId = targetUserId,
                Data = new Dictionary<string, string>
                {
                    ["Type"] = SendSilentToUserDto.LocationRequested,
                    ["RequesterId"] = requesterId,
                    ["FareId"] = fareId.ToString()
                }
            });
    }

    public async Task SendLocation(FareLocationDto dto)
    {
        var senderId = GetUserId();
        var targetUserId = await ValidateFareLocationAccess(dto.FareId, senderId);
        dto.UserId = targetUserId;
        dto.IsAccurate = true;

        cache.Set(GetCacheKey(senderId), dto, CacheTtl);

        var connectionId = tracker.Get(targetUserId.ToString());
        if (connectionId != null)
            await Clients.Client(connectionId)
                .SendAsync("ReceiveLocation", dto);
    }

    public async Task GetLastLocation(int fareId)
    {
        var callerId = GetUserId();
        var targetUserId = await ValidateFareLocationAccess(fareId, callerId);
        var targetKey = targetUserId.ToString();

        cache.TryGetValue(GetCacheKey(targetKey), out var cachedValue);
        if (cachedValue != null)
        {
            (cachedValue as FareLocationDto)!.IsAccurate = false;
            cache.Set(GetCacheKey(targetKey), cachedValue, CacheTtl);

            await Clients.Caller.SendAsync("ReceiveLocation", cachedValue);
        }
        else
        {
            await using var scope = scopeFactory.CreateAsyncScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();
            var city = await dbContext.Users.Where(it => it.Id == targetUserId).Select(it => it.City).FirstAsync();
            var dto = new FareLocationDto
            {
                FareId = fareId,
                DateTime = DateTime.UtcNow,
                Lat = city!.Lat,
                Lon = city!.Long,
                UserId = targetUserId,
                IsAccurate = false
            };
            cache.Set(GetCacheKey(targetKey), dto, CacheTtl);

            await Clients.Caller.SendAsync("ReceiveLocation", dto);
        }
    }
}