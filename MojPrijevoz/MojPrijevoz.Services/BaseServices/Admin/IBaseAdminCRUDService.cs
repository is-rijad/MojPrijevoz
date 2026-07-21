using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels.Admin;
using MojPrijevoz.Model.Requests.Admin.RequestChanges;

namespace MojPrijevoz.Services.BaseServices.Admin;

public interface
    IBaseAdminCRUDService<TInsertRequest, TUpdateRequest, TRequestChangesEntity, TResponse, TAllResponse,
        TSearchObject> : IBaseAdminService<
    TResponse, TAllResponse, TSearchObject> where TInsertRequest : class
    where TUpdateRequest : class
    where TRequestChangesEntity : BaseRequestChanges
    where TAllResponse : class
    where TResponse : TAllResponse
    where TSearchObject : OrderableSearchObject
{
    public Task<TResponse> InsertWithTransactionAsync(TInsertRequest request);
    public Task<TResponse> InsertAsync(TInsertRequest request);
    public Task<TResponse> UpdateAsync(int id, TUpdateRequest request);
    public Task<TResponse> UpdateWithTransactionAsync(int id, TUpdateRequest request);
    public Task<TResponse> RequestChangesAsync(int id, RequestChangesRequest request);
    public Task DeleteAsync(int id);
}