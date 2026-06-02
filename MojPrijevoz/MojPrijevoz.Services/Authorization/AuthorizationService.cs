using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
using System.Data.SqlTypes;
using System.Security.Cryptography;
using System.Text;

namespace MojPrijevoz.Services.Authorization;

public class AuthorizationService {
    private const int HashByteSize = 32;
    private const int SaltByteSize = 16;
    private const int Iterations = 100000;
    private readonly MojPrijevozDbContext _dbContext;
    private readonly HashAlgorithmName _hashAlgorithm = HashAlgorithmName.SHA256;

    private readonly TokenManager _tokenManager;

    public AuthorizationService(MojPrijevozDbContext context, TokenManager tokenManager) {
        _dbContext = context;
        _tokenManager = tokenManager;
    }

    public async Task<AccessTokenResponse> Login(UserLoginRequest request) {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u =>
            u.Username == request.UsernameOrEmail || u.Email == request.UsernameOrEmail);
        if (user == null || !VerifyPassword(request.Password, user.PasswordHash, user.PasswordSalt))
            throw new BadRequestException("Uneseni podaci nisu ispravni");
        if (user.Status == AccountStatus.Banned)
            throw new BadRequestException("Vaš račun je blokiran. Kontaktirajte podršku za više informacija.");

        var token = await _tokenManager.GenerateToken(user);

        return new AccessTokenResponse
        {
            Token = token
        };
    }

    public async Task<AccessTokenResponse> GetNewToken() {
        var userId = GetUserId();

        var user = await _dbContext.Users.FirstAsync(u =>
            u.Id == userId);

        var token = await _tokenManager.GenerateToken(user);

        return new AccessTokenResponse
        {
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

    public string CreateResetPasswordCode(out string code, out DateTime expiration) {

        code = RandomNumberGenerator.GetInt32(10_000_000, 100_000_000).ToString();
        var bytes = Encoding.UTF8.GetBytes(code);
        var hash = SHA256.HashData(bytes);
        var hashString = Convert.ToBase64String(hash);
        expiration = DateTime.UtcNow.AddMinutes(15);

        return hashString;
    }

    public void VerifyResetPasswordCode(string code, string realHash, DateTime expiration) {
        if (expiration < DateTime.UtcNow)
            throw new BadRequestException("Reset kod je istekao. Molimo zatražite novi kod.");

        var bytes = Encoding.UTF8.GetBytes(code);
        var hash = SHA256.HashData(bytes);
        var hashString = Convert.ToBase64String(hash);
        if (hashString != realHash)
            throw new BadRequestException("Kod nije ispravan.");
    }


    public bool VerifyPassword(string password, string storedHash, string storedSalt) {
        var saltBytes = Convert.FromBase64String(storedSalt);
        using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        var hash = Convert.ToBase64String(hashBytes);
        return hash == storedHash;
    }

    public int GetUserId() {
        return _tokenManager.GetUserId();
    }

    public async Task<int?> GetProfileId(ProfileType profileType) {
        return (await GetUserProfile(profileType))?.Id;
    }

    public async Task<Database.UserProfile?> GetUserProfile(ProfileType profileType) {
        return await _dbContext.UserProfiles
            .Where(up => up.UserId == GetUserId() && up.ProfileType == profileType)
            .FirstOrDefaultAsync();
    }
}