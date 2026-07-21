namespace MojPrijevoz.Recommender.Helpers;

public class RouteIndex
{
    private Dictionary<string, uint> _map = new();
    private uint _next;

    public uint GetOrAdd(string routeKey)
    {
        if (_map.TryGetValue(routeKey, out var id)) return id;
        _map[routeKey] = _next;
        return _next++;
    }

    public uint? Get(string routeKey)
    {
        return _map.TryGetValue(routeKey, out var id) ? id : null;
    }

    public Dictionary<string, uint> GetMap()
    {
        return _map;
    }

    public void LoadFrom(Dictionary<string, uint> map)
    {
        _map = map;
        _next = map.Values.DefaultIfEmpty().Max() + 1;
    }
}