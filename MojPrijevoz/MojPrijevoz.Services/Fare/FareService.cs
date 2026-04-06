using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Fare;

public class FareService : BaseCrudService<Database.Fare, FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>, IFareService {
    public FareService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService) {
    }
    public async Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request) {
        var queryable = _dbContext.Fares.Where(it =>
            it.FareDateTime.Date == request.FareDateTime.Date
        );
        queryable = queryable.Where(it => it.OriginCityId == request.OriginCityId);
        queryable = queryable.Where(it => it.DestinationLat == request.DestinationCity.DestinationLat &&
                                          it.DestinationLong == request.DestinationCity.DestinationLong);
        queryable = queryable.Where(it => it.PassengerId == passengerId);


        return await queryable.AnyAsync();
    }
}