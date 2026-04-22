using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.Fare;

public interface IFareService : IBaseCRUDService<FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>, IBaseState {
    public Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request);
    public Task<FareResponse> AcceptAsync(int id);
    public Task<FareResponse> RejectAsync(int id);
    public Task<FareResponse> CancelAsync(int id);
    public Task<FareResponse> CompleteAsync(int id);
    public Task<FareResponse> StartAsync(int id);
    public Task<PagedResult<FareResponse>> GetNextAcceptedFaresAsync(FareSearchObject searchObject);
}