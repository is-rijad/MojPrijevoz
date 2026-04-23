using System.Collections.Concurrent;

namespace MojPrijevoz.Services.InMemoryDatabase;

public class ConnectionTracker {
    private readonly ConcurrentDictionary<string, string> _map = new();

    public void Register(string userId, string connectionId) => _map[userId] = connectionId;
    public void Remove(string userId) => _map.TryRemove(userId, out _);
    public string? Get(string userId) => _map.TryGetValue(userId, out var cid) ? cid : null;
}