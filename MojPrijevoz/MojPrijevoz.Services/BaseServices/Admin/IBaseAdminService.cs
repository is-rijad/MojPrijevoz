using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.BaseModels.Admin;

namespace MojPrijevoz.Services.BaseServices.Admin;

public interface IBaseAdminService<TResponse, TAllResponse, TSearchObject>  where TAllResponse : class
    where TResponse : TAllResponse
    where TSearchObject : OrderableSearchObject {
    public Task<PagedResult<TAllResponse>> GetAsync(TSearchObject searchObject);
    public Task<TResponse> GetByIdAsync(int id);
}