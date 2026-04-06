using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Services.BaseServices;

public interface IBaseService<TResponse, TSearchObject> where TResponse : class
    where TSearchObject : BaseSearchObject {
    public Task<PagedResult<TResponse>> GetAsync(TSearchObject searchObject);
    public Task<TResponse> GetByIdAsync(int id);
}