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
using MojPrijevoz.Services.UserVehicle.StateMachine;

namespace MojPrijevoz.Services.Admin;

public class AdminUserVehiclesService : BaseAdminCrudService<Database.UserVehicle, TPlaceholder,
    AdminUserVehicleUpdateRequest, UserVehicleRequestChanges, AdminUserVehicleResponse, AdminAllUserVehiclesResponse,
    AdminUserVehicleSearchObject>
{
    private readonly INotificationService _notificationService;
    private readonly BaseUserVehicleRequestChangesState _userVehicleRequestChangesState;
    private static readonly Dictionary<string, string> _translatedFields = new()
    {
        ["modelYear"] = "Godina proizvodnje",
        ["pricePerKm"] = "Cijena po kilometru",
        ["picture"] = "Slika",
    };

    public AdminUserVehiclesService(MojPrijevozDbContext context, IMapper mapper,
        AuthorizationService authorizationService,
        INotificationService notificationService,
        BaseUserVehicleRequestChangesState userVehicleRequestChangesState) : base(context, mapper,
        authorizationService, _translatedFields)
    {
        _notificationService = notificationService;
        _userVehicleRequestChangesState = userVehicleRequestChangesState;
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

    protected override async Task AfterUpdate(Database.UserVehicle entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        if (IsReactivated<UserVehicleStatus>(entity, UserVehicleStatus.WaitingForReview, UserVehicleStatus.Active))
        {
            var userVehicle = await _dbContext.UserVehicles.Include(it => it.Vehicle).Include(it => it.Profile)
                .ThenInclude(it => it!.User).FirstOrDefaultAsync(it => it.Id == entity.Id);
            
            await _notificationService.SendEmailAsync(new EmailDto
            {
                To = userVehicle!.Profile!.User!.Email,
                Type = EmailType.UserVehicleActivatedEmail,
                Data = new Dictionary<string, dynamic>
                {
                    ["Name"] = userVehicle.Profile!.User!.FirstName,
                    ["VehicleName"] = $"{userVehicle.Vehicle!.ToString()} ({userVehicle.ModelYear})",
                }
            });
        }
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
        var state = _userVehicleRequestChangesState.GetState((short)userVehicle.Status);
        state.RequestChanges(userVehicle);
    }

    public override UserVehicleRequestChanges MapIdToRequestChanges(int id, UserVehicleRequestChanges entity)
    {
        entity.UserVehicleId = id;
        return entity;
    }

    public override async Task SendNotificationEmail(List<UserVehicleRequestChanges> entities)
    {
        var user = await _dbContext.UserVehicles
            .Select(it => new
            {
                UserVehicleId = it.Id,
                User = it.Profile!.User
            })
            .FirstAsync(it => it!.UserVehicleId == entities.First().UserVehicleId);
        await _notificationService.SendEmailAsync(new EmailDto
        {
            To = user!.User!.Email,
            Type = EmailType.UserVehicleRequestChangesEmail,
            Data = new Dictionary<string, dynamic>
            {
                ["Name"] = user.User!.FirstName,
                ["Changes"] = entities
            }
        });
    }

    protected override async Task BeforeDelete(int id, Database.UserVehicle entity)
    {
        await base.BeforeDelete(id, entity);
        if (await _dbContext.Fares.AnyAsync(it => it.UserVehicleId == id && (it.Status == FareStatus.InNegotiation ||
                                                                             it.Status == FareStatus.Accepted ||
                                                                             it.Status == FareStatus.InProgress ||
                                                                             it.Status == FareStatus.Payed)))
            throw new BadRequestException("Ne možete obrisati vozilo koje ima aktivanu vožnju!");
        entity.Status = UserVehicleStatus.Deleted;
        entity.VehicleId = null;
    }
    
}