using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.City;
using MojPrijevoz.Model.Responses.Admin.City;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;

namespace MojPrijevoz.Services.Admin;

public class AdminCityService : BaseAdminCrudService<Database.City, AdminCityUpsertRequest, AdminCityUpsertRequest,
    BaseRequestChanges, AdminCityResponse, AdminAllCitiesResponse, AdminCitySearchObject>
{
    public AdminCityService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService)
    {
    }

    public override async Task<IQueryable<Database.City>> ApplyFilter(IQueryable<Database.City> queryable,
        AdminCitySearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains))
            queryable = queryable.Where(it => it.Name.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Lat.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Long.ToLower().Contains(searchObject.Contains.ToLower()));
        return queryable;
    }

    protected override async Task BeforeDelete(int id, Database.City entity)
    {
        await base.BeforeDelete(id, entity);
        var hasUsersFromCity = await _dbContext.Users.AnyAsync(it => it.CityId == id);
        if (hasUsersFromCity) throw new BadRequestException("Ne možete obrisati grad dok ima korisnika iz istog!");
    }

    public override Task BeforeRequestChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity)
    {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities)
    {
        throw new NotImplementedException();
    }
}