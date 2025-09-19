using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Model.Authorization;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
using System.Security.Cryptography;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.Auth;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Authorization;

public class AuthorizationService : BaseService<TPlaceholder, AuthResponse, Database.User, BaseSearchObject> {
    private const int HashByteSize = 32;
    private const int SaltByteSize = 16;
    private const int Iterations = 100000;

    private readonly TokenManager _tokenManager;
    private readonly HashAlgorithmName _hashAlgorithm = HashAlgorithmName.SHA256;

    public AuthorizationService(MojPrijevozDbContext context, IMapper mapper, TokenManager tokenManager) : base(context, mapper) {
        _tokenManager = tokenManager;
    }

    public async Task<UserLoginResponse> Login(UserLoginRequest request) {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u =>
            u.Username == request.Username || u.Email == request.Username);
        if (user == null || !VerifyPassword(request.Password, user.PasswordHash, user.PasswordSalt))
            throw new BadRequestException("Uneseni podaci nisu ispravni");

        var tokenDto = new UserInfoTokenDto
        {
            Username = user.Username,
            Email = user.Email,
            UserId = user.Id
        };

        var role = await _dbContext.Administrators.FindAsync(user.Id);
        if (role != null)
            tokenDto.Role = Convert.ToInt32(role.Role);

        var token = _tokenManager.GenerateToken(tokenDto);

        return new UserLoginResponse
        {
            UserId = user.Id,
            Token = token
        };
    }

    public void CreatePassword(string password, string passwordAgain, out string hash, out string salt) {
        if (password != passwordAgain)
            throw new BadRequestException("Lozinke se ne podudaraju.");
        using var rng = RandomNumberGenerator.Create();
        var saltBytes = new byte[SaltByteSize];
        rng.GetBytes(saltBytes);
        salt = Convert.ToBase64String(saltBytes);

        using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        hash = Convert.ToBase64String(hashBytes);
    }


    public bool VerifyPassword(string password, string storedHash, string storedSalt) {
        var saltBytes = Convert.FromBase64String(storedSalt);
        using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        var hash = Convert.ToBase64String(hashBytes);
        return hash == storedHash;
    }

    public int GetUserId()
    {
        return _tokenManager.GetUserId();
    }

    public async Task<int?> GetProfileId(ProfileType profileType)
    {
        return (await GetUserProfile(profileType))?.Id;
    }
    public async Task<UserProfile?> GetUserProfile(ProfileType profileType) {
        return (await _dbContext.UserProfiles
            .Where(up => up.UserId == GetUserId() && up.ProfileType == profileType)
            .FirstOrDefaultAsync());
    }
}