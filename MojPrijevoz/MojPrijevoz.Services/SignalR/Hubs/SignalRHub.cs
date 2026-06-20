using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.FareLocation;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.SignalR.Hubs;

[Authorize]
public class SignalRHub(
    IMemoryCache cache,
    ConnectionTracker tracker,
    INotificationService notificationService,
    IServiceScopeFactory scopeFactory) : Hub {
    public static readonly TimeSpan CacheTtl = TimeSpan.FromHours(24);
    public static string GetCacheKey(string userId) => $"loc:{userId}";

    public override Task OnConnectedAsync() {
        var userId = Context.UserIdentifier!;
        tracker.Register(userId, Context.ConnectionId);
        return base.OnConnectedAsync();
    }

    public override Task OnDisconnectedAsync(Exception? ex) {
        var userId = Context.UserIdentifier!;
        tracker.Remove(userId);
        return base.OnDisconnectedAsync(ex);
    }

    public async Task SendProximityNotification(ProximityNotificationDto dto)
    {
        await notificationService.SendToUserAsync(new SendToUserDto()
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
    public async Task RequestLocation(string targetUserId) {
        var requesterId = Context.UserIdentifier!;
        var connectionId = tracker.Get(targetUserId);

        if (connectionId != null) {
            await Clients.Client(connectionId)
                .SendAsync("LocationRequested", requesterId);
        }
        else {
            await notificationService.SendSilentToUserAsync(new SendSilentToUserDto()
            {
                UserId = int.Parse(targetUserId),
                Data = new Dictionary<string, string>
                {
                    ["Type"] = SendSilentToUserDto.LocationRequested,
                    ["RequesterId"] = requesterId
                }
            });
        }
    }

    public async Task SendLocation(FareLocationDto dto) {
        var senderId = Context.UserIdentifier!;
        var connectionId = tracker.Get(dto.UserId.ToString());
        dto.IsAccurate = true;

        cache.Set(GetCacheKey(senderId), dto, CacheTtl);

        if (connectionId != null) {
            await Clients.Client(connectionId)
                .SendAsync("ReceiveLocation", dto);
        }
    }

    public async Task GetLastLocation(string userId) {
        cache.TryGetValue(GetCacheKey(userId), out var cachedValue);
        if (cachedValue != null) {
            ((cachedValue as FareLocationDto)!).IsAccurate = false;
            cache.Set(GetCacheKey(userId), cachedValue, CacheTtl);

            await Clients.Caller.SendAsync("ReceiveLocation", cachedValue);
        }
        else
        {
            await RequestLocation(userId);
            await using var scope = scopeFactory.CreateAsyncScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();
            var parsedUserId = int.Parse(userId);
            var city = await dbContext.Users.Where(it => it.Id == parsedUserId).Select(it => it.City).FirstAsync();
            var dto = new FareLocationDto()
            {
                DateTime = DateTime.UtcNow,
                Lat = city!.Lat,
                Lon = city!.Long,
                UserId = parsedUserId,
                IsAccurate = false
            };
            cache.Set(GetCacheKey(userId), dto, CacheTtl);

            await Clients.Caller.SendAsync("ReceiveLocation", dto);
        }
    }
}