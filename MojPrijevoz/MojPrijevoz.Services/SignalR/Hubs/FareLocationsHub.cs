using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using MojPrijevoz.Model.Dtos.FareLocation;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.SignalR.Hubs;

public class FareLocationsHub(
    IMemoryCache cache,
    ConnectionTracker tracker,
    INotificationService notificationService) : Hub {
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

    public async Task RequestLocation(string targetUserId) {
        var requesterId = Context.UserIdentifier!;
        var connectionId = tracker.Get(targetUserId);

        if (connectionId != null) {
            await Clients.Client(connectionId)
                .SendAsync("LocationRequested", requesterId);
        }
        else
        {
            await notificationService.SendSilentToUserAsync(new SendSilentToUserDto()
            {
                UserId = int.Parse(targetUserId),
                Data = new Dictionary<string, string>
                {
                    ["Type"] = SendSilentToUserDto.LocationRequested,
                    ["RequesterId"] = requesterId
                }});
        }
    }

    public async Task SendLocation(FareLocationDto dto) {
        var senderId = Context.UserIdentifier!;
        var connectionId = tracker.Get(dto.UserId.ToString());

        if (connectionId != null) {
            cache.Set(GetCacheKey(senderId), dto, CacheTtl);
            await Clients.Client(connectionId)
                .SendAsync("ReceiveLocation", dto);
        }
    }

    public async Task GetLastLocation(string userId)
    {
        cache.TryGetValue(GetCacheKey(userId), out var cachedValue);
        if (cachedValue != null)
        {
            await Clients.Caller.SendAsync("ReceiveLocation", cachedValue);
        }
        else
        {
            await RequestLocation(userId);
        }
    }
}