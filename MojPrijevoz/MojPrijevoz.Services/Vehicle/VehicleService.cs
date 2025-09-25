using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.Vehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Vehicle;

public class VehicleService : BaseCrudService<Database.Vehicle, TPlaceholder, TPlaceholder, VehicleResponse,
    VehicleResponse, VehicleSearchObject>
{
    public VehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService)
    {
    }

    public override IQueryable<Database.Vehicle> ApplyFilter(IQueryable<Database.Vehicle> queryable,
        VehicleSearchObject searchObject)
    {
        if (!string.IsNullOrWhiteSpace(searchObject.Contains))
            queryable = queryable.Where(v => v.Model.Contains(searchObject.Contains)
                                             || v.Manufacturer.Contains(searchObject.Contains) ||
                                             (v.Manufacturer + " " + v.Model).Contains(searchObject.Contains));
        return queryable;
    }
}