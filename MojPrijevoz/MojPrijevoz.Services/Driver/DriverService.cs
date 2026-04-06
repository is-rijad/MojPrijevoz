using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.Driver;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Driver;

public class DriverService : BaseService<DriverResponse, Database.User, DriverSearchObject> {
    public DriverService(MojPrijevozDbContext dbContext, IMapper mapper) : base(dbContext, mapper) {
    }
}