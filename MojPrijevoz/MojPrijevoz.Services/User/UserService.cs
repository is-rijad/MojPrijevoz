using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.FormRequests.User;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.User;

public class UserService : BaseCrudService<Database.User, UserInsertRequest, UserUpdateFormRequest, UserResponse,
    BaseSearchObject> {
    private readonly INotificationService _notificationService;
    private readonly RevokedTokenService _revokedTokenService;
    private readonly TokenManager _tokenManager;

    public UserService(MojPrijevozDbContext context, IMapper mapper,
        AuthorizationService authorizationService,
        IFileStorageService fileStorageService,
        INotificationService notificationService,
        RevokedTokenService revokedTokenService,
        TokenManager tokenManager
        ) : base(context, mapper, authorizationService, fileStorageService) {
        _notificationService = notificationService;
        _revokedTokenService = revokedTokenService;
        _tokenManager = tokenManager;
    }

    protected override async Task BeforeInsert(UserInsertRequest request) {
        await base.BeforeInsert(request);
        if (await _dbContext.Users.AnyAsync(u => u.Username == request.Username || u.Email == request.Email))
            throw new BadRequestException("Korisničko ime ili email već postoji.");
    }

    protected override Database.User MapToInsertEntity(UserInsertRequest request) {
        var userInsertRequest = _mapper.Map<Database.User>(request);
        _authorizationService.CreatePassword(request.Password, request.PasswordAgain, out var passwordHash,
            out var passwordSalt);
        (userInsertRequest.PasswordHash, userInsertRequest.PasswordSalt) = (passwordHash, passwordSalt);
        return userInsertRequest;
    }

    protected override async Task AfterInsert(Database.User entity, UserInsertRequest request, MojPrijevozDbContext dbContext) {
        await base.AfterInsert(entity, request, dbContext);
        if (!(await _dbContext.UserProfiles.Where(it => it.UserId == entity.Id).AnyAsync())) {
            await _dbContext.UserProfiles.AddAsync(new Database.UserProfile
            {
                ProfileType = ProfileType.Passenger,
                UserId = entity.Id
            });
        }
        await dbContext.SaveChangesAsync();
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = entity.Email,
            Type = EmailType.WelcomeEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = entity.FirstName
            }
        });
    }

    protected override async Task BeforeUpdate(int id, UserUpdateFormRequest request, Database.User entity) {
        await base.BeforeUpdate(id, request, entity);
        if (request.OldPassword is not null || request.Password is not null || request.PasswordAgain is not null) {
            if (!_authorizationService.VerifyPassword(request.OldPassword ?? string.Empty, entity.PasswordHash,
                    entity.PasswordSalt))
                throw new BadRequestException("Stara lozinka nije ispravna.");
            if (request.Password is null || request.PasswordAgain is null)
                throw new BadRequestException("Nove lozinke moraju biti unesene.");
            _authorizationService.CreatePassword(request.Password, request.PasswordAgain, out var passwordHash,
                out var passwordSalt);
            (entity.PasswordHash, entity.PasswordSalt) = (passwordHash, passwordSalt);
            (request.Password, request.PasswordAgain, request.OldPassword) = (null, null, null);
            await _notificationService.SendEmailAsync(new EmailDto()
            {
                To = entity.Email,
                Type = EmailType.PasswordChangedEmail,
                Data = new Dictionary<string, dynamic>()
                {
                    ["Name"] = entity.FirstName,
                    ["Username"] = entity.Username,
                }
            });
        }
    }

    protected override async Task AfterUpdate(Database.User entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        var requestedChanges = await _dbContext.UserRequestChanges.Where(it => it.UserId == entity.Id).ToListAsync();
        _dbContext.RemoveRange(requestedChanges);
    }

    public async Task<RequestResetPasswordResponse> RequestResetPasswordCode(RequestResetPasswordRequest request) {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
        if (user == null)
            throw new BadRequestException("Korisnik s unesenim emailom ne postoji.");
        var hash = _authorizationService.CreateResetPasswordCode(out var code, out var expiration);
        user.ResetPasswordCode = hash;
        user.ResetPasswordCodeExpiration = expiration;

        await _dbContext.SaveChangesAsync();
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = user.Email,
            Type = EmailType.ResetPasswordEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = user.FirstName,
                ["Code"] = code
            }
        });
        return new RequestResetPasswordResponse() { Code = code };
    }

    public async Task ResetPassword(ResetPasswordRequest request) {
        var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
        if (user == null)
            throw new BadRequestException("Korisnik s unesenim emailom ne postoji.");

        _authorizationService.VerifyResetPasswordCode(request.Code, user.ResetPasswordCode!, user.ResetPasswordCodeExpiration!.Value);
        user.ResetPasswordCode = null;
        user.ResetPasswordCodeExpiration = null;
        if (request.Password != request.PasswordAgain)
            throw new BadRequestException("Lozinke se ne podudaraju.");
        _authorizationService.CreatePassword(request.Password, request.PasswordAgain, out var passwordHash,
            out var passwordSalt);
        (user.PasswordHash, user.PasswordSalt) = (passwordHash, passwordSalt);
        _revokedTokenService.Revoke(user.Id, null);
        await _tokenManager.DropRefreshTokenIfExists(user.Id);

        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = user.Email,
            Type = EmailType.PasswordChangedEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = user.FirstName,
                ["Username"] = user.Username,
            }
        });

        await _dbContext.SaveChangesAsync();
    }
}