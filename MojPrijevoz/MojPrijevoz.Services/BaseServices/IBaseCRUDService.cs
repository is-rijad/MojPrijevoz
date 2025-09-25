using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Services.BaseServices;

public interface
    IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TDetailedResponse, TSearchObject> : IBaseService<
        TResponse, TDetailedResponse, TSearchObject> where TInsertRequest : class
    where TUpdateRequest : class
    where TResponse : class
    where TDetailedResponse : class
    where TSearchObject : BaseSearchObject
{
    public Task<TDetailedResponse> InsertAsync(TInsertRequest request);
    public Task<TDetailedResponse> UpdateAsync(int id, TUpdateRequest request);
    public Task DeleteAsync(int id);
}