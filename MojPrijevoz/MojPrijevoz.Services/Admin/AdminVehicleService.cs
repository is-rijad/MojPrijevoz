using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.Admin.Vehicle;
using MojPrijevoz.Model.Responses.Admin.Vehicle;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;

namespace MojPrijevoz.Services.Admin;

public class AdminVehicleService : BaseAdminCrudService<Database.Vehicle, AdminUpsertVehicleRequest, AdminUpsertVehicleRequest, BaseRequestChanges, AdminVehicleResponse, AdminAllVehiclesResponse, AdminVehicleSearchObject> {
    public AdminVehicleService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService) {
    }

    public override async Task<IQueryable<Database.Vehicle>> ApplyFilter(IQueryable<Database.Vehicle> queryable, AdminVehicleSearchObject searchObject) {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains)) {
            queryable = queryable.Where(it => it.Manufacturer.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Model.ToLower().Contains(searchObject.Contains.ToLower()));
        }
        return queryable;
    }

    public override Task BeforeRequestChanges(int id) {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id) {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity) {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities) {
        throw new NotImplementedException();
    }
}