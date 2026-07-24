using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.Vehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Vehicle;

public class VehicleService : BaseCrudService<Database.Vehicle, TPlaceholder, TPlaceholder, VehicleResponse,
    VehicleSearchObject>
{
    public VehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService)
    {
    }

    protected override IQueryable<Database.Vehicle> ApplyOrdering(IQueryable<Database.Vehicle> queryable, VehicleSearchObject searchObject)
    {
        queryable = queryable.OrderBy(it => it.Manufacturer).ThenBy(it => it.Model).ThenBy(it => it.Id);
        return queryable;
    }

    public override Task<IQueryable<Database.Vehicle>> ApplyFilter(IQueryable<Database.Vehicle> queryable,
        VehicleSearchObject searchObject)
    {
        if (!string.IsNullOrWhiteSpace(searchObject.Contains))
            queryable = queryable.Where(v => v.Model.ToLower().Contains(searchObject.Contains.ToLower())
                                             || v.Manufacturer.ToLower().Contains(searchObject.Contains.ToLower()) ||
                                             (v.Manufacturer + " " + v.Model).ToLower().Contains(searchObject.Contains.ToLower()));
        return Task.FromResult(queryable);
    }
}