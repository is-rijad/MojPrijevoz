using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.City;

public class CityService : BaseService<CityResponse, Database.City, CitySearchObject>
{
    public CityService(MojPrijevozDbContext dbContext,
        IMapper mapper,
        AuthorizationService authorizationService) : base(dbContext, mapper)
    {
    }

    public override Task<IQueryable<Database.City>> ApplyFilter(IQueryable<Database.City> queryable,
        CitySearchObject searchObject)
    {
        if (!string.IsNullOrWhiteSpace(searchObject.Contains))
            queryable = queryable.Where(c => c.Name.Contains(searchObject.Contains));
        return Task.FromResult(queryable);
    }
}