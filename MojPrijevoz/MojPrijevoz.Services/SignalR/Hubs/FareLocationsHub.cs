using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using MojPrijevoz.Model.Dtos.Nominatim;
using MojPrijevoz.Services.InMemoryDatabase;

namespace MojPrijevoz.Services.SignalR.Hubs;

public class FareLocationsHub(
    IMemoryCache cache,
    ConnectionTracker tracker,
    PendingLocationRequests pending) : Hub {
    private static readonly TimeSpan CacheTtl = TimeSpan.FromHours(24);
    private string GetCacheKey(string userId) => $"loc:{userId}";

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
    public async Task GetCachedLocation(string userId)
    {
            // TODO: temp
            await Clients.Caller.SendAsync("ReceiveLocation", new NominatimCityDto()
            {
                Lat = "43.8563",
                Long = "18.4131"
            });
       
        return;
        if (cache.TryGetValue(GetCacheKey(userId), out NominatimCityDto? cached))
        {
            await Clients.Caller.SendAsync("ReceiveLocation", cached);
        }
        else
        {
            await RequestLocation(userId);
        }

    }

    public async Task RequestLocation(string userId) {

        pending.Add(userId, Context.ConnectionId);

        var connId = tracker.Get(userId);
        if (connId is not null)
            await Clients.Client(connId).SendAsync("SendYourLocation");
    }

    public async Task UpdateLocation(string lat, string lng) {
        var userId = Context.UserIdentifier!;
        var dto = new NominatimCityDto() {Lat = lat, Long = lng};

        cache.Set(GetCacheKey(userId), dto, CacheTtl);

        var waiter = pending.Pop(userId);
        if (waiter != null)
            await Clients.Client(waiter).SendAsync("ReceiveLocation", dto);
    }
}