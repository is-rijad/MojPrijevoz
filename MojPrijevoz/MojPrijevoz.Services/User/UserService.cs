using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Model.Authorization;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.Database;

namespace MojPrijevoz.Services.User;

public class UserService : IUserService
{
    private const int HashByteSize = 32;
    private const int SaltByteSize = 16;
    private const int Iterations = 100000;

    private readonly MojPrijevozDbContext _context;
    private readonly HashAlgorithmName _hashAlgorithm = HashAlgorithmName.SHA256;
    private readonly TokenManager _tokenManager;

    public UserService(MojPrijevozDbContext context,
        TokenManager tokenManager)
    {
        _context = context;
        _tokenManager = tokenManager;
    }

    public async Task<UserLoginResponse> Login(UserLoginRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u =>
            u.Username == request.Username || u.Email == request.Username);
        if (user == null || !VerifyPassword(request.Password, user.PasswordHash, user.PasswordSalt))
            throw new Exception("Uneseni podaci nisu ispravni");

        var tokenDto = new UserInfoTokenDto
        {
            Username = user.Username,
            Email = user.Email,
            UserId = user.Id
        };

        var role = await _context.Administrators.FindAsync(user.Id);
        if (role != null)
            tokenDto.Role = Convert.ToInt32(role.Role);

        var token = _tokenManager.GenerateToken(tokenDto);

        return new UserLoginResponse
        {
            UserId = user.Id,
            Token = token
        };
    }

    public bool VerifyPassword(string password, string storedHash, string storedSalt)
    {
        var saltBytes = Convert.FromBase64String(storedSalt);
        using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        var hash = Convert.ToBase64String(hashBytes);
        return hash == storedHash;
    }

    public async Task CreateUser(UserInsertRequest request)
    {
        if (await _context.Users.AnyAsync(u => u.Username == request.Username || u.Email == request.Email))
            throw new Exception("Korisničko ime ili email već postoji.");
        CreatePassword(request.Password, out var passwordHash, out var passwordSalt);
        var user = (await _context.Users.AddAsync(new Database.User
        {
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email,
            Username = request.Username,
            PasswordHash = passwordHash,
            PasswordSalt = passwordSalt,
            CityId = request.CityId
        })).Entity;
        user.UserProfiles.Add(new UserProfile
        {
            ProfileType = ProfileType.Passenger,
            User = user
        });
        await _context.SaveChangesAsync();
    }

    private void CreatePassword(string password, out string hash, out string salt)
    {
        using var rng = RandomNumberGenerator.Create();
        var saltBytes = new byte[SaltByteSize];
        rng.GetBytes(saltBytes);
        salt = Convert.ToBase64String(saltBytes);

        using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, _hashAlgorithm);
        var hashBytes = pbkdf2.GetBytes(HashByteSize);
        hash = Convert.ToBase64String(hashBytes);
    }
}