using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Services.BaseServices;

public interface
    IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TSearchObject> : IBaseService<
        TResponse, TSearchObject> where TInsertRequest : class
    where TUpdateRequest : class
    where TResponse : class
    where TSearchObject : BaseSearchObject {
    public Task<TResponse> InsertWithTransactionAsync(TInsertRequest request);
    public Task<TResponse> InsertAsync(TInsertRequest request);
    public Task<TResponse> UpdateAsync(int id, TUpdateRequest request);
    public Task<TResponse> UpdateWithTransactionAsync(int id, TUpdateRequest request);
    public Task DeleteAsync(int id);
}