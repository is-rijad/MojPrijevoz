using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.UserVehicle;
using MojPrijevoz.Model.Responses.Admin.UserVehicle;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminUserVehiclesService : BaseAdminCrudService<Database.UserVehicle, TPlaceholder,
    AdminUserVehicleUpdateRequest, UserVehicleRequestChanges, AdminUserVehicleResponse, AdminAllUserVehiclesResponse,
    AdminUserVehicleSearchObject>
{
    private readonly INotificationService _notificationService;

    public AdminUserVehiclesService(MojPrijevozDbContext context, IMapper mapper,
        AuthorizationService authorizationService,
        INotificationService notificationService) : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
    }

    public override async Task<IQueryable<Database.UserVehicle>> ApplyFilter(IQueryable<Database.UserVehicle> queryable,
        AdminUserVehicleSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        queryable = queryable.Where(it => it.Status != UserVehicleStatus.Deleted);
        if (!string.IsNullOrEmpty(searchObject.Contains))
            queryable = queryable.Where(it => it.Vehicle!.Model.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Vehicle!.Manufacturer.ToLower()
                                                  .Contains(searchObject.Contains.ToLower())
                                              || it.Profile!.User!.FirstName.ToLower()
                                                  .Contains(searchObject.Contains.ToLower())
                                              || it.Profile!.User!.LastName.ToLower()
                                                  .Contains(searchObject.Contains.ToLower())
                                              || it.LicensePlate.ToLower().Contains(searchObject.Contains.ToLower())
            );
        return queryable;
    }

    public override async Task<IQueryable<Database.UserVehicle>> IncludeAdditionalEntities(
        IQueryable<Database.UserVehicle> queryable)
    {
        queryable = await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.Profile).ThenInclude(it => it!.User);
        queryable = queryable.Include(it => it.Vehicle);
        return queryable;
    }

    protected override async Task PrepareForResponse(Database.UserVehicle entity, MojPrijevozDbContext dbContext)
    {
        await base.PrepareForResponse(entity, dbContext);
        entity.Vehicle = await _dbContext.Vehicles.FindAsync(entity.VehicleId);
        entity.Profile = await _dbContext.UserProfiles.Include(it => it.User).Where(it => it.Id == entity.ProfileId)
            .FirstAsync();
    }

    public override async Task BeforeRequestChanges(int id)
    {
        if (await _dbContext.UserVehicles.AnyAsync(it =>
                it.Id == id && it.Profile!.User!.Status == AccountStatus.Banned))
            throw new BadRequestException("Ne možete zatražiti izmjene za banovanog korisnika!");
        if (await _dbContext.UserVehicleRequestChanges.AnyAsync(it => it.UserVehicleId == id && !it.IsEdited))
            throw new BadRequestException("Već ste zatražili izmjene za ovo vozilo!");
    }

    public override async Task SetEntityStatusToWaitingForChanges(int id)
    {
        var userVehicle = await _dbContext.UserVehicles.FindAsync(id);
        if (userVehicle is null) throw new NotFoundException("Vozilo nije pronađeno!");
        userVehicle.Status = UserVehicleStatus.WaitingForChanges;
    }

    public override UserVehicleRequestChanges MapIdToRequestChanges(int id, UserVehicleRequestChanges entity)
    {
        entity.UserVehicleId = id;
        return entity;
    }

    public override async Task SendNotificationEmail(List<UserVehicleRequestChanges> entities)
    {
        var userVehicle = await _dbContext.UserVehicles.Include(it => it.Profile).ThenInclude(it => it!.User)
            .FirstAsync(it => it.Id == entities.First().UserVehicleId);
        await _notificationService.SendEmailAsync(new EmailDto
        {
            To = userVehicle.Profile!.User!.Email,
            Type = EmailType.UserVehicleRequestChangesEmail,
            Data = new Dictionary<string, dynamic>
            {
                ["Name"] = userVehicle.Profile!.User!.FirstName,
                ["Changes"] = entities
            }
        });
    }
}