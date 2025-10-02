using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.City;

public class AdminCityService : BaseCrudService<Database.City, CityInsertRequest, CityUpdateRequest,
    AdminCityResponse, CitySearchObject>
{
    public AdminCityService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService)
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