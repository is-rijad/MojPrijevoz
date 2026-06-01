using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.UserVehicle;
using MojPrijevoz.Model.Responses.UserVehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.FormRequests.UserVehicle;

namespace MojPrijevoz.Services.UserVehicle;

public class UserVehicleService : BaseCrudService<Database.UserVehicle, UserVehicleUpsertFormRequest,
    UserVehicleUpsertFormRequest, UserVehicleResponse, UserVehicleSearchObject> {
    public UserVehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, IFileStorageService fileStorageService) :
        base(context, mapper, authorizationService, fileStorageService) {
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
        }
        else {
            if (await _dbContext.UserVehicles.AnyAsync(uv =>
                    uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear))
                throw new BadRequestException("Vozilo već postoji.");
        }

        await _dbContext.SaveChangesAsync();
        request.ProfileId = profile.Id;
    }

    protected override async Task BeforeUpdate(int id, UserVehicleUpsertFormRequest request, Database.UserVehicle entity)
    {
        await base.BeforeUpdate(id, request, entity);
        var profileId = await _authorizationService.GetProfileId(ProfileType.Driver);
        var profile = await _dbContext.UserProfiles.FindAsync(profileId);
        if (await _dbContext.UserVehicles.AnyAsync(uv =>
                uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear &&
                uv.Id != entity.Id))
            throw new BadRequestException("Vozilo već postoji.");
    }

    protected override Database.UserVehicle MapToUpdateEntity(UserVehicleUpsertFormRequest request, Database.UserVehicle entity)
    {
        var updateEntity = base.MapToUpdateEntity(request, entity);
        updateEntity.PricePerKm /= 10;
        return updateEntity;
    }

    protected override Database.UserVehicle MapToInsertEntity(UserVehicleUpsertFormRequest request)
    {
        var insertEntity = base.MapToInsertEntity(request);
        insertEntity.PricePerKm /= 10;
        return insertEntity;
    }
}