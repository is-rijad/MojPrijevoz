using MapsterMapper;
using Microsoft.AspNetCore.Http;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.City;

public class CityService : BaseService<CityResponse, CityResponse, Database.City, Model.SearchObjects.CitySearchObject> {
    public CityService(MojPrijevozDbContext dbContext,
        IMapper mapper,
        IAuthorizationService authorizationService) : base(dbContext, mapper)
    {
    }
    public override IQueryable<Database.City> ApplyFilter(IQueryable<Database.City> queryable, Model.SearchObjects.CitySearchObject searchObject)
    {
        if (!string.IsNullOrWhiteSpace(searchObject.Contains))
        {
            queryable = queryable.Where(c => c.Name.Contains(searchObject.Contains));
        }
        return queryable;
    }
}