using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Authorization;

namespace MojPrijevoz.Services.Authorization;

public class TokenManager
{
    private const string PictureClaimType = "picture";
    private const string PassengerProfileIdClaimType = "passenger_profile_id";
    private const string DriverProfileIdClaimType = "driver_profile_id";
    private readonly IConfiguration _configuration;
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IMapper _mapper;

    public TokenManager(IConfiguration configuration, IHttpContextAccessor httpContextAccessor,
        MojPrijevozDbContext dbContext, IMapper mapper)
    {
        _configuration = configuration;
        _httpContextAccessor = httpContextAccessor;
        _dbContext = dbContext;
        _mapper = mapper;
    }

    private string JwtKey =>
        _configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key is not configured.");

    private string JwtIssuer => _configuration["Jwt:Issuer"] ??
                                throw new InvalidOperationException("JWT Issuer is not configured.");

    private string JwtExpiration => _configuration["Jwt:ExpirationInMinutes"] ??
                                    throw new InvalidOperationException("JWT Expiration is not configured.");

    public async Task<string> GenerateToken(Database.User user)
    {
        var tokenDto = await GetTokenDto(user);
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(JwtKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, tokenDto.Id.ToString()),
            new(JwtRegisteredClaimNames.Name, tokenDto.FirstName),
            new(JwtRegisteredClaimNames.FamilyName, tokenDto.LastName),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new(PassengerProfileIdClaimType, tokenDto.PassengerProfileId.ToString())
        };
        if (tokenDto.Role.HasValue) claims.Add(new Claim(ClaimTypes.Role, tokenDto.Role.Value.ToString()));
        if (tokenDto.Picture != null) claims.Add(new Claim(PictureClaimType, tokenDto.Picture));
        if (tokenDto.DriverProfileId.HasValue)
            claims.Add(new Claim(DriverProfileIdClaimType, tokenDto.DriverProfileId.ToString()));

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
        var id = int.Parse(jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Sub).Value);
        var firstName = jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Email).Value;
        var lastName = jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Email).Value;
        var passengerProfileId = int.Parse(jwtToken.Claims.First(c => c.Type == PassengerProfileIdClaimType).Value);
        var driverProfileClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == DriverProfileIdClaimType);
        int? driverProfileId = driverProfileClaim != null ? int.Parse(driverProfileClaim.Value) : null;
        var pictureClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == PictureClaimType);
        var picture = pictureClaim?.Value;
        var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role);
        int? role = roleClaim != null ? int.Parse(roleClaim.Value) : null;


        return new UserInfoTokenDto
        {
            Id = id,
            FirstName = firstName,
            LastName = lastName,
            PassengerProfileId = passengerProfileId,
            DriverProfileId = driverProfileId,
            Picture = picture,
            Role = role
        };
    }

    public int GetUserId()
    {
        return Convert.ToInt32(_httpContextAccessor.HttpContext!.User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
    }

    public int? GetProfileId(ProfileType profileType)
    {
        var claimType = profileType == ProfileType.Passenger ? PassengerProfileIdClaimType : DriverProfileIdClaimType;
        var profileIdString = _httpContextAccessor.HttpContext!.User.FindFirst(claimType)?.Value;
        if (profileIdString == null)
            return null;
        return int.Parse(profileIdString);
    }

    private async Task<UserInfoTokenDto> GetTokenDto(Database.User user)
    {
        var tokenDto = _mapper.Map<UserInfoTokenDto>(user);

        tokenDto.PassengerProfileId = await _dbContext.UserProfiles
            .Where(up => up.UserId == user.Id)
            .Select(up => up.Id)
            .FirstAsync();

        var driverProfile = (await _dbContext.UserProfiles
            .Where(up => up.UserId == user.Id && up.ProfileType == ProfileType.Driver)
            .FirstOrDefaultAsync())?.Id;
        if (driverProfile != null)
            tokenDto.DriverProfileId = driverProfile.Value;

        var role = await _dbContext.Administrators.FindAsync(user.Id);
        if (role != null)
            tokenDto.Role = Convert.ToInt32(role.Role);

        return tokenDto;
    }
}