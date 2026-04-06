using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.FareOffer;

public interface IFareOfferService : IBaseCRUDService<FareOfferInsertRequest, FareOfferInsertRequest, FareOfferResponse, FareOfferSearchObject> {

}