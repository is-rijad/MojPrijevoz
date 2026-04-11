using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Fare;

public class FareService : BaseCrudService<Database.Fare, FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>, IFareService {
    public FareService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService) {
    }
    public async Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request)
    {
        var queryable = _dbContext.Fares.Where(it =>
            it.FareData!.FareDateTime.Date == request.FareDateTime.Date
        );
        queryable = queryable.Where(it => it.FareData!.OriginCityId == request.OriginCityId);
        queryable = queryable.Where(it => it.FareData!.DestinationLat == request.DestinationCity.DestinationLat &&
                                          it.FareData!.DestinationLong == request.DestinationCity.DestinationLong);
        queryable = queryable.Where(it => it.PassengerId == passengerId);
        
        
        return await queryable.AnyAsync();
    }

    public override async Task<IQueryable<Database.Fare>> ApplyFilter(IQueryable<Database.Fare> queryable, FareSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        var profileId = await _authorizationService.GetProfileId(searchObject.FareRole);

        if (profileId == null)
            throw new BadRequestException("Profil nije pronađen!");

        if (searchObject.FareRole == ProfileType.Driver)
        {
            queryable = queryable.Where(it => it.DriverId == profileId);
        }
        else if (searchObject.FareRole == ProfileType.Passenger)
        {
            queryable = queryable.Where(it => it.PassengerId == profileId);
        }
        return queryable;
    }

    public override async Task<IQueryable<Database.Fare>> IncludeAdditionalEntities(IQueryable<Database.Fare> queryable)
    {
        queryable = await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.FareData)
            .ThenInclude(it => it!.FareOffers)
            .Include(it => it.Driver)
            .ThenInclude(it => it!.User)
            .Include(it => it.Passenger)
            .ThenInclude(it => it!.User)
            .Include(it => it.FareData)
            .ThenInclude(it => it!.StopPoints);
        return queryable;
    }
}