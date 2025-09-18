using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Services.BaseServices;

public interface IBaseService<TResponse, TDetailedResponse, TSearchObject> where TResponse: class where TDetailedResponse : class where TSearchObject: BaseSearchObject {
    public Task<PagedResult<TResponse>> GetAsync(TSearchObject searchObject);
    public Task<TDetailedResponse> GetByIdAsync(int id);
}