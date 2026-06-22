using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
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
        Account? account = await _dbContext.Users.FirstOrDefaultAsync(u =>
            u.Username == request.UsernameOrEmail || u.Email == request.UsernameOrEmail);
        if (account == null)
        {
            account = await _dbContext.Administrators.FirstOrDefaultAsync(u =>
                u.Username == request.UsernameOrEmail || u.Email == request.UsernameOrEmail);
        }
        if (account == null || !VerifyPassword(request.Password, account.PasswordHash, account.PasswordSalt))
            throw new BadRequestException("Uneseni podaci nisu ispravni");
        if (account.Status == AccountStatus.Banned)
            throw new BadRequestException("Vaš račun je blokiran. Kontaktirajte podršku za više informacija.");

        var token = await _tokenManager.GenerateToken(account);
        var refreshToken = await _tokenManager.GenerateRefreshToken(account);

        await ChangeOrAddRefreshToken(refreshToken, account.Id);

        return new AccessTokenResponse
        {
            Token = token,
            RefreshToken = refreshToken
        };
    }

    private async Task ChangeOrAddRefreshToken(string refreshToken, int userId) {

        var refreshTokenEntity = await _dbContext.RefreshTokens.FirstOrDefaultAsync(rt => rt.UserId == userId);
        HashRefreshToken(refreshToken, out var hash, out var salt);

        if (refreshTokenEntity == null) {
            await _dbContext.RefreshTokens.AddAsync(new RefreshToken() {TokenHash = hash, UserId = userId, TokenSalt = salt});
        }
        else {
            refreshTokenEntity.TokenHash = hash;
            refreshTokenEntity.TokenSalt = salt;
        }
        await _dbContext.SaveChangesAsync();

    }
    public async Task<AccessTokenResponse> Refresh(RefreshTokenRequest request) {
        var userId = _tokenManager.GetUserInfoFromToken(request.AccessToken).Id;
        Account? account = await _dbContext.Users.FirstOrDefaultAsync(it => it.Id == userId);
        if (account == null)
        {
            account = await _dbContext.Administrators.FirstOrDefaultAsync(it => it.Id == userId);
        }
        var refreshTokenEntity = await _dbContext.RefreshTokens.FirstOrDefaultAsync(rt =>
            rt.UserId == userId);

        if (refreshTokenEntity == null) {
            throw new BadRequestException("Korisnik nije ulogovan.");
        }

        if (!VerifyRefreshToken(request.RefreshToken, refreshTokenEntity.TokenHash, refreshTokenEntity.TokenSalt)) {
            throw new BadRequestException("Neispravan refresh token.");
        }

        var token = await _tokenManager.GenerateToken(account!);
        var refreshToken = await _tokenManager.GenerateRefreshToken(account!);

        await ChangeOrAddRefreshToken(refreshToken, userId);

        return new AccessTokenResponse
        {
            Token = token,
            RefreshToken = refreshToken
        };
    }

    public void HashRefreshToken(string refreshToken, out string hash, out string salt) {
        using var rng = RandomNumberGenerator.Create();
        var saltBytes = new byte[SaltByteSize];
        rng.GetBytes(saltBytes);
        salt = Convert.ToBase64String(saltBytes);

        using var pbkdf2 = new Rfc2898DeriveBytes(refreshToken, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        hash = Convert.ToBase64String(hashBytes);
    }

    public bool VerifyRefreshToken(string refreshToken, string storedHash, string storedSalt) {
        var saltBytes = Convert.FromBase64String(storedSalt);
        using var pbkdf2 = new Rfc2898DeriveBytes(refreshToken, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        var hash = Convert.ToBase64String(hashBytes);
        return hash == storedHash;
    }

    public async Task<AccessTokenResponse> GetNewToken() {
        var userId = GetUserId();

        var user = await _dbContext.Accounts.FirstAsync(u =>
            u.Id == userId);

        var token = await _tokenManager.GenerateToken(user);
        var refreshToken = await _tokenManager.GenerateRefreshToken(user);

        await ChangeOrAddRefreshToken(refreshToken, userId);

        return new AccessTokenResponse
        {
            Token = token,
            RefreshToken = refreshToken
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