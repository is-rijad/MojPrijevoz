using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.FareData;
using MojPrijevoz.Model.Responses.FareData;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.FareData;

public class FareDataService :
    BaseCrudService<Database.FareData, FareDataInsertRequest, FareDataInsertRequest, FareDataResponse,
        FareDataSearchObject>, IFareDataService
{
    public FareDataService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper, authorizationService)
    {
    }
}