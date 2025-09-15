using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using MojPrijevoz.Model.Authorization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace MojPrijevoz.Services.Authorization;

public class TokenManager
{
    private readonly IConfiguration _configuration;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public TokenManager(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
    {
        _configuration = configuration;
        _httpContextAccessor = httpContextAccessor;
    }

    private string JwtKey =>
        _configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key is not configured.");

    private string JwtIssuer => _configuration["Jwt:Issuer"] ??
                                throw new InvalidOperationException("JWT Issuer is not configured.");

    private string JwtExpiration => _configuration["Jwt:ExpirationInMinutes"] ??
                                    throw new InvalidOperationException("JWT Expiration is not configured.");

    public string GenerateToken(UserInfoTokenDto tokenDto)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(JwtKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, tokenDto.UserId.ToString()),
            new(JwtRegisteredClaimNames.Email, tokenDto.Email),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new("username", tokenDto.Username)
        };
        if (tokenDto.Role.HasValue) claims.Add(new Claim(ClaimTypes.Role, tokenDto.Role.Value.ToString()));

        var token = new JwtSecurityToken(
            JwtIssuer,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(Convert.ToDouble(JwtExpiration)),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public UserInfoTokenDto GetUserInfoFromToken(string token)
    {
        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);
        if (jwtToken == null)
            throw new InvalidOperationException("Invalid token!");
        var userId = int.Parse(jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Sub).Value);
        var email = jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Email).Value;
        var username = jwtToken.Claims.First(c => c.Type == "Username").Value;
        var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role);
        int? role = roleClaim != null ? int.Parse(roleClaim.Value) : null;
        return new UserInfoTokenDto
        {
            UserId = userId,
            Email = email,
            Username = username,
            Role = role
        };
    }

    public int GetUserId()
    {
        return Convert.ToInt32(_httpContextAccessor.HttpContext!.User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
    }
}