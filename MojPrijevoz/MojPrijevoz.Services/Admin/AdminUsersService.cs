using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.User;
using MojPrijevoz.Model.Responses.Admin.Users;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;

namespace MojPrijevoz.Services.Admin;

public class AdminUsersService : BaseAdminCrudService<Database.User, TPlaceholder, AdminUserUpdateRequest, UserRequestChanges, UserResponse, UsersResponse, UsersSearchObject>
{
    public AdminUsersService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService)
    {
    }

    public override async Task<IQueryable<Database.User>> ApplyFilter(IQueryable<Database.User> queryable, UsersSearchObject searchObject)
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

    }

    public override UserRequestChanges MapIdToRequestChanges(int id, UserRequestChanges entity)
    {
        entity.UserId = id;
        return entity;
    }

    public override Task SendNotificationEmail(List<UserRequestChanges> entities)
    {
        return Task.CompletedTask;
    }
}