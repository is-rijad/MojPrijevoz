using Microsoft.Extensions.Caching.Memory;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.InMemoryDatabase;

public class RevokedTokenService
{
    private readonly IMemoryCache _cache;
    private readonly TokenManager _tokenManager;
    private string GetKey(int userId) => "revoked_token_" + userId;
    private int GetCacheTtl(string token) => _tokenManager.GetExpirationInMinutes(token);

    public RevokedTokenService(IMemoryCache cache, TokenManager tokenManager)
    {
        _cache = cache;
        _tokenManager = tokenManager;
    }

    public DateTime? GetRevokedRecord(int userId)
    {
        if(_cache.TryGetValue(GetKey(userId), out DateTime revokedAt))
            return revokedAt;
        return null;
    }

    public void DropKeyIfExists(int userId)
    {
        _cache.Remove(GetKey(userId));
    }

    public void Revoke(int userId, string? token)
    {
        var ttl = token != null ? GetCacheTtl(token) : int.Parse(Environment.GetEnvironmentVariable("Jwt__ExpirationInMinutes") ?? throw new ArgumentException("Jwt:ExpirationInMinutes is not set"));
        _cache.Set(GetKey(userId), DateTime.UtcNow, TimeSpan.FromMinutes(ttl));
    }
}