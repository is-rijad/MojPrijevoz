using MojPrijevoz.Model.Requests.FareData;
using MojPrijevoz.Model.Responses.FareData;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.FareData;

public interface IFareDataService : IBaseCRUDService<FareDataInsertRequest, FareDataInsertRequest, FareDataResponse, FareDataSearchObject> {

}