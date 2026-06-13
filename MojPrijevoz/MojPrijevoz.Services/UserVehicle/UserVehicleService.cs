using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Responses.UserVehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.FormRequests.UserVehicle;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.UserVehicle;

public class UserVehicleService : BaseCrudService<Database.UserVehicle, UserVehicleUpsertFormRequest,
    UserVehicleUpsertFormRequest, UserVehicleResponse, UserVehicleSearchObject> {
    private readonly INotificationService _notificationService;

    public UserVehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        IFileStorageService fileStorageService, INotificationService notificationService) :
        base(context, mapper, authorizationService, fileStorageService) {
        _notificationService = notificationService;
    }

    public override Task<IQueryable<Database.UserVehicle>> ApplyFilter(IQueryable<Database.UserVehicle> queryable,
        UserVehicleSearchObject searchObject) {
        return Task.FromResult(queryable.Where(uv => uv.ProfileId == searchObject.ProfileId));
    }

    protected override async Task PrepareForResponse(Database.UserVehicle entity, MojPrijevozDbContext dbContext) {
        entity.Vehicle = await dbContext.Vehicles.FindAsync(entity.VehicleId);
        await base.PrepareForResponse(entity, dbContext);
    }

    public override async Task<IQueryable<Database.UserVehicle>> IncludeAdditionalEntities(
        IQueryable<Database.UserVehicle> queryable) {
        queryable = await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(uv => uv.Vehicle);
        return queryable;
    }

    protected override async Task BeforeInsert(UserVehicleUpsertFormRequest request) {
        await base.BeforeInsert(request);
        var userId = _authorizationService.GetUserId();
        var profile = await _authorizationService.GetUserProfile(ProfileType.Driver);
        if (profile is null) {
            profile = (await _dbContext.UserProfiles.AddAsync(new Database.UserProfile
            {
                UserId = userId,
                ProfileType = ProfileType.Driver
            })).Entity;
            request.IsFirstVehicle = true;
        }
        else {
            if (await _dbContext.UserVehicles.AnyAsync(uv =>
                    uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear))
                throw new BadRequestException("Vozilo već postoji.");
        }

        await _dbContext.SaveChangesAsync();
        request.ProfileId = profile.Id;
    }

    protected override async Task AfterInsert(Database.UserVehicle entity, UserVehicleUpsertFormRequest request, MojPrijevozDbContext dbContext) {
        await base.AfterInsert(entity, request, dbContext);
        var user = await dbContext.UserProfiles.Where(u => u.Id == entity.ProfileId).Select(it => it.User).FirstAsync();
        var vehicle = await dbContext.Vehicles.FirstAsync(v => v.Id == entity.VehicleId);
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = user.Email,
            Type = EmailType.BecomeDriverEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = user.FirstName,
                ["Vehicle"] = vehicle.ToString() + " (" + entity.ModelYear + ")"
            }
        });
    }

    protected override async Task BeforeUpdate(int id, UserVehicleUpsertFormRequest request, Database.UserVehicle entity) {
        await base.BeforeUpdate(id, request, entity);
        var profileId = await _authorizationService.GetProfileId(ProfileType.Driver);
        var profile = await _dbContext.UserProfiles.FindAsync(profileId);
        if (await _dbContext.UserVehicles.AnyAsync(uv =>
                uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear &&
                uv.Id != entity.Id))
            throw new BadRequestException("Vozilo već postoji.");
    }

    protected override Database.UserVehicle MapToUpdateEntity(UserVehicleUpsertFormRequest request, Database.UserVehicle entity) {
        var updateEntity = base.MapToUpdateEntity(request, entity);
        updateEntity.PricePerKm /= 10;
        return updateEntity;
    }

    protected override Database.UserVehicle MapToInsertEntity(UserVehicleUpsertFormRequest request) {
        var insertEntity = base.MapToInsertEntity(request);
        insertEntity.PricePerKm /= 10;
        return insertEntity;
    }
}