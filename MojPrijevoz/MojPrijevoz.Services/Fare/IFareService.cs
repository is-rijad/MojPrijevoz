using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Fare;

public interface IFareService : IBaseCRUDService<FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>
{
    public Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request);

}