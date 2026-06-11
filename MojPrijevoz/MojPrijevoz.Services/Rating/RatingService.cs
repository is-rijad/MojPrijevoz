using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Rating;
using MojPrijevoz.Model.Responses.Rating;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;

namespace MojPrijevoz.Services.Rating;

public class RatingService : BaseCrudService<Database.Rating, RatingInsertRequest, RatingInsertRequest, RatingResponse, RatingSearchObject>, IRatingService
{
    public RatingService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, IFileStorageService? fileStorageService = null) : base(context, mapper, authorizationService, fileStorageService)
    {
    }

    public override async Task<IQueryable<Database.Rating>> ApplyFilter(IQueryable<Database.Rating> queryable, RatingSearchObject searchObject)
    {
        await base.ApplyFilter(queryable, searchObject);
        queryable = queryable.Where(it => it.ToId == searchObject.ProfileId);
        return queryable;
    }

    public override async Task<IQueryable<Database.Rating>> IncludeAdditionalEntities(IQueryable<Database.Rating> queryable)
    {
        await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.From).ThenInclude(it => it!.User);
        return queryable;
    }

    protected override async Task BeforeInsert(RatingInsertRequest request)
    {
        await base.BeforeInsert(request);
        var fare = await _dbContext.Fares.FindAsync(request.FareId);
        if (fare == null)
            throw new NotFoundException("Vožnja nije pronađena!");
        if (request.ProfileType == ProfileType.Passenger)
        {
            if (fare.PassengerId != await _authorizationService.GetProfileId(ProfileType.Passenger))
            {
                throw new BadRequestException("Niste bili putnik u ovoj vožnji!");
            }

            request.FromId = fare.PassengerId;
            request.ToId = fare.DriverId;
        }
        else
        {
            if (fare.DriverId != await _authorizationService.GetProfileId(ProfileType.Driver)) {
                throw new BadRequestException("Niste bili vozač u ovoj vožnji!");
            }
            request.ToId = fare.PassengerId;
            request.FromId = fare.DriverId;
        }
    }
}