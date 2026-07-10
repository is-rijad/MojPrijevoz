using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.City;

public class AdminCityService : BaseCrudService<Database.City, CityInsertRequest, CityUpdateRequest,
    AdminCityResponse, CitySearchObject> {
    public AdminCityService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService) {
    }

    public override Task<IQueryable<Database.City>> ApplyFilter(IQueryable<Database.City> queryable,
        CitySearchObject searchObject) {
        if (!string.IsNullOrWhiteSpace(searchObject.Contains))
            queryable = queryable.Where(c => c.Name.Contains(searchObject.Contains));
        return Task.FromResult(queryable);
    }

    protected override async Task BeforeDelete(int id, Database.City entity)
    {
        await base.BeforeDelete(id, entity);
        var hasUsersFromCity = await _dbContext.Users.AnyAsync(it => it.CityId == id);
        if (hasUsersFromCity)
        {
            throw new BadRequestException("Ne možete obrisati grad dok ima korisnika iz istog!");
        }
    }
}