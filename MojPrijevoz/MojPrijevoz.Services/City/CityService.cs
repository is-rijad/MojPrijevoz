using MapsterMapper;
using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Database;

namespace MojPrijevoz.Services.City;

public class CityService : BaseService<CityResponse, Database.City, Model.SearchObjects.CitySearchObject> {
    public CityService(MojPrijevozDbContext dbContext,
        IMapper mapper) : base(dbContext, mapper)
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