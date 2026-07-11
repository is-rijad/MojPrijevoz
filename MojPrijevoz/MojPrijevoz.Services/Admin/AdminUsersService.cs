using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.User;
using MojPrijevoz.Model.Responses.Admin.User;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminUsersService : BaseAdminCrudService<Database.User, TPlaceholder, AdminUserUpdateRequest, UserRequestChanges, AdminUsersResponse, AdminAllUsersResponse, AdminUserSearchObject>
{
    private readonly INotificationService _notificationService;
    private readonly TokenManager _tokenManager;
    private readonly RevokedTokenService _revokedTokenService;

    public AdminUsersService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        INotificationService notificationService, RevokedTokenService revokedTokenService,
        TokenManager tokenManager) : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
        _revokedTokenService = revokedTokenService;
        _tokenManager = tokenManager;
    }

    public override async Task<IQueryable<Database.User>> ApplyFilter(IQueryable<Database.User> queryable, AdminUserSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains))
        {
            queryable = queryable.Where(it => it.FirstName.ToLower().Contains(searchObject.Contains.ToLower())
            || it.LastName.ToLower().Contains(searchObject.Contains.ToLower())
            || it.Email.ToLower().Contains(searchObject.Contains.ToLower())
            || it.Username.ToLower().Contains(searchObject.Contains.ToLower())
            || it.PhoneNumber.ToLower().Contains(searchObject.Contains.ToLower()));
        }
        return queryable;
    }

    public override async Task BeforeRequestChanges(int id)
    {
        if (await _dbContext.Users.Where(it => it.Id == id).Select(it => it.Status).FirstAsync() == AccountStatus.Banned) {
            throw new BadRequestException("Ne možete tražiti izmjene za banovanog korisnika!");
        }
        if (await _dbContext.UserRequestChanges.AnyAsync(it => it.UserId == id && !it.IsEdited)) {
            throw new BadRequestException("Već ste zatražili izmjene za ovog korisnika!");
        }

    }

    public override async Task SetEntityStatusToWaitingForChanges(int id)
    {
        var user = await _dbContext.Users.FindAsync(id);
        if (user is null)
        {
            throw new NotFoundException("Korisnik nije pronađen!");
        }
        user.Status = AccountStatus.WaitingForChanges;

        _revokedTokenService.Revoke(id, null);
    }

    public override UserRequestChanges MapIdToRequestChanges(int id, UserRequestChanges entity)
    {
        entity.UserId = id;
        return entity;
    }

    public override async Task SendNotificationEmail(List<UserRequestChanges> entities)
    {
        var userProfile = await _dbContext.UserProfiles.Include(it => it!.User)
            .FirstAsync(it => it.UserId == entities.First().UserId);
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = userProfile.User!.Email,
            Type = EmailType.UserRequestChangesEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = userProfile.User!.FirstName,
                ["Changes"] = entities
            }
        });
    }

    protected override async Task AfterUpdate(Database.User entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        if (entity.Status == AccountStatus.Banned)
        {
            await _notificationService.SendEmailAsync(new EmailDto()
            {
                To = entity.Email,
                Type = EmailType.UserBannedEmail,
                Data = new Dictionary<string, dynamic>()
                {
                    ["Name"] = entity.FirstName,
                    ["Username"] = entity.Username
                }
            });
            await _tokenManager.DropRefreshTokenIfExists(entity.Id);
        }
        _revokedTokenService.Revoke(entity.Id, null);
    }
}