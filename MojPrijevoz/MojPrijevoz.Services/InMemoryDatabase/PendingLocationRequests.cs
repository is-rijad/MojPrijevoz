namespace MojPrijevoz.Services.InMemoryDatabase;

public class PendingLocationRequests {
    private readonly Dictionary<string, string> _pending = new();

    public void Add(string driverId, string passengerConnId)
        => _pending.Add(driverId, passengerConnId);

    public string? Pop(string driverId)
    {
        _pending.TryGetValue(driverId, out var passengerConnId);
        if (passengerConnId != null)
        {
            _pending.Remove(driverId);
        }

        return passengerConnId ?? null;
    }
}