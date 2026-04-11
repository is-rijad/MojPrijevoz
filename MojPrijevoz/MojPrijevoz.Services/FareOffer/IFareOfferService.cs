using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.FareOffer;

public interface IFareOfferService : IBaseCRUDService<FareOfferInsertRequest, FareOfferUpdateRequest, FareOfferResponse, FareOfferSearchObject>, IBaseState {
    public Task<FareOfferResponse> AcceptOfferAsync(int id);
    public Task<FareOfferResponse> RejectOfferAsync(int id);
    public Task<FareOfferResponse> ExpireOfferAsync(int id);

}