using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Admin.Vehicle;
using MojPrijevoz.Model.Responses.Admin.Vehicle;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminVehicleService : BaseAdminCrudService<Database.Vehicle, AdminUpsertVehicleRequest,
    AdminUpsertVehicleRequest, BaseRequestChanges, AdminVehicleResponse, AdminAllVehiclesResponse,
    AdminVehicleSearchObject>
{
    private readonly INotificationService _notificationService;

    public AdminVehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        INotificationService notificationService)
        : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
    }

    private async Task<List<Database.User>> GetAffectedUsers(int vehicleId)
    {
        return await _dbContext.UserVehicles
            .Where(uv => uv.VehicleId == vehicleId)
            .Include(uv => uv.Profile).ThenInclude(p => p!.User)
            .Select(uv => uv.Profile!.User!)
            .Distinct()
            .ToListAsync();
    }

    protected override async Task AfterUpdate(Database.Vehicle entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        var affectedUsers = await GetAffectedUsers(entity.Id);
        foreach (var user in affectedUsers)
        {
            await _notificationService.SendEmailAsync(new EmailDto
            {
                To = user.Email,
                Type = EmailType.VehicleModelUpdatedEmail,
                Data = new Dictionary<string, dynamic>
                {
                    ["Name"] = user.FirstName,
                    ["VehicleName"] = entity.ToString()!
                }
            });
        }
    }

    protected override async Task BeforeDelete(int id, Database.Vehicle entity)
    {
        await base.BeforeDelete(id, entity);
        var affectedUsers = await GetAffectedUsers(id);
        foreach (var user in affectedUsers)
        {
            await _notificationService.SendEmailAsync(new EmailDto
            {
                To = user.Email,
                Type = EmailType.VehicleModelDeletedEmail,
                Data = new Dictionary<string, dynamic>
                {
                    ["Name"] = user.FirstName,
                    ["VehicleName"] = entity.ToString()!
                }
            });
        }
    }

    public override async Task<IQueryable<Database.Vehicle>> ApplyFilter(IQueryable<Database.Vehicle> queryable,
        AdminVehicleSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains))
            queryable = queryable.Where(it => it.Manufacturer.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Model.ToLower().Contains(searchObject.Contains.ToLower())
                                              || (it.Manufacturer.ToLower() + " " + it.Model.ToLower()).Contains(searchObject.Contains.ToLower())
                                              );
        return queryable;
    }

    protected override IQueryable<Database.Vehicle> ApplyOrdering(IQueryable<Database.Vehicle> queryable, AdminVehicleSearchObject searchObject)
    {
        if (!string.IsNullOrEmpty(searchObject.OrderBy))
            return base.ApplyOrdering(queryable, searchObject);
        return queryable.OrderBy(it => it.Manufacturer).ThenBy(it => it.Model).AsQueryable();
    }

    public override Task BeforeRequestChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity)
    {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities)
    {
        throw new NotImplementedException();
    }
}