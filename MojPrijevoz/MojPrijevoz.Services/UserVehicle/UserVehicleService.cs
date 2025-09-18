using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Requests.UserVehicle;
using MojPrijevoz.Model.Responses.UserVehicle;
using MojPrijevoz.Services.BaseServices;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.UserVehicle;

public class UserVehicleService : BaseCrudService<Database.UserVehicle, UserVehicleUpsertRequest,
    UserVehicleUpsertRequest, UserVehicleResponse, UserVehicleResponse, BaseSearchObject>
{
    public UserVehicleService(MojPrijevozDbContext context, IMapper mapper, IAuthorizationService authorizationService) : base(context, mapper, authorizationService)
    {
    }

    protected override async Task BeforeInsert(UserVehicleUpsertRequest request)
    {
        await base.BeforeInsert(request);
        var userId = _authorizationService.GetUserId();
        var profile = await _authorizationService.GetUserProfile(ProfileType.Driver);
        if (profile is null) {
            profile = (await _dbContext.UserProfiles.AddAsync(new UserProfile
            {
                UserId = userId,
                ProfileType = ProfileType.Driver
            })).Entity;
        }
        else
        {
            if (await _dbContext.UserVehicles.AnyAsync(uv => uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear))
                throw new BadRequestException("Vozilo već postoji.");
        }
        request.ProfileId = profile.Id;
    }

    protected override async Task BeforeUpdate(int id, UserVehicleUpsertRequest request, Database.UserVehicle entity)
    {
        await base.BeforeUpdate(id, request, entity);
        var profileId = await _authorizationService.GetProfileId(ProfileType.Driver);
        var profile = await _dbContext.UserProfiles.FindAsync(profileId);
        if (await _dbContext.UserVehicles.AnyAsync(uv => uv.Profile == profile && uv.VehicleId == request.VehicleId && uv.ModelYear == request.ModelYear))
            throw new BadRequestException("Vozilo već postoji.");
    }
}