using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.Administrators;
using MojPrijevoz.Model.Responses.Admin.Administrators;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminAdministratorService : BaseAdminCrudService<Database.Administrator, AdminAdministratorUpsertRequest, AdminAdministratorUpsertRequest, BaseRequestChanges, AdminAdministratorResponse, AdminAllAdministratorsResponse, AdminAdministratorSearchObject> {
    private readonly INotificationService _notificationService;
    private readonly RevokedTokenService _revokedTokenService;
    private readonly TokenManager _tokenManager;

    public AdminAdministratorService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        INotificationService notificationService, RevokedTokenService revokedTokenService,
        TokenManager tokenManager) : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
        _revokedTokenService = revokedTokenService;
        _tokenManager = tokenManager;
    }

    public override async Task<IQueryable<Database.Administrator>> ApplyFilter(IQueryable<Database.Administrator> queryable, AdminAdministratorSearchObject searchObject) {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains)) {
            queryable = queryable.Where(it => it.FirstName.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.LastName.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Email.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Username.ToLower().Contains(searchObject.Contains.ToLower()));
        }
        return queryable;
    }

    protected override async Task BeforeInsert(AdminAdministratorUpsertRequest request) {
        await base.BeforeInsert(request);
        if (await _dbContext.Administrators.AnyAsync(u => u.Username == request.Username || u.Email == request.Email))
            throw new BadRequestException("Korisničko ime ili email već postoji.");

        var password = _authorizationService.GenerateRandomPassword();
        _authorizationService.CreatePassword(password, password, out var passwordHash,
            out var passwordSalt);
        (request.PasswordHash, request.PasswordSalt) = (passwordHash, passwordSalt);
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = request.Email,
            Type = EmailType.BecomeAdministratorEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = request.FirstName,
                ["NewPassword"] = password
            }
        });
    }

    protected override Database.Administrator MapToInsertEntity(AdminAdministratorUpsertRequest request) {
        return _mapper.Map<Database.Administrator>(request);
    }

    protected override async Task BeforeUpdate(int id, AdminAdministratorUpsertRequest request, Database.Administrator entity) {
        await base.BeforeUpdate(id, request, entity);
        if (request.ChangePassword)
        {
            var password = _authorizationService.GenerateRandomPassword();
            _authorizationService.CreatePassword(password, password, out var passwordHash,
                out var passwordSalt);
            (entity.PasswordHash, entity.PasswordSalt) = (passwordHash, passwordSalt);
            await _notificationService.SendEmailAsync(new EmailDto()
            {
                To = request.Email,
                Type = EmailType.AdministratorPasswordChangedEmail,
                Data = new Dictionary<string, dynamic>()
                {
                    ["Name"] = request.FirstName,
                    ["NewPassword"] = password
                }
            });
            _revokedTokenService.Revoke(id, null);
            await _tokenManager.DropRefreshTokenIfExists(id);
        }
    }

    protected override async Task AfterUpdate(Administrator entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        if (entity.Status == AccountStatus.Banned)
        {
            await _notificationService.SendEmailAsync(new EmailDto()
            {
                To = entity.Email,
                Type = EmailType.AdministratorBannedEmail,
                Data = new Dictionary<string, dynamic>()
                {
                    ["Name"] = entity.FirstName,
                }
            });
            _revokedTokenService.Revoke(entity.Id, null);
            await _tokenManager.DropRefreshTokenIfExists(entity.Id);
        }

    }

    public override Task BeforeRequestChanges(int id) {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id) {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity) {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities) {
        throw new NotImplementedException();
    }
}