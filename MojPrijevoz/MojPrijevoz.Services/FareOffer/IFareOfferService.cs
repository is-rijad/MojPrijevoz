using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.Responses.FareData;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.FareOffer;

public interface IFareOfferService : IBaseCRUDService<FareOfferInsertRequest, FareOfferUpdateRequest, FareResponse, FareOfferSearchObject>, IBaseState {
    public Task<FareResponse> AcceptOfferAsync(int id);
    public Task<FareResponse> RejectOfferAsync(int id);
    public Task<FareResponse> ExpireOfferAsync(int id);
    public Task<FareResponse> CancelOfferAsync(int id);
    public Task<FareResponse> PayOfferAsync(int id);
    public Task MarkAsExpired();

}