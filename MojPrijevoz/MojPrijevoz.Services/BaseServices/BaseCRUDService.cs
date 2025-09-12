using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;

namespace MojPrijevoz.Services.BaseServices;

public abstract class BaseCrudService<TEntity, TInsertRequest, TUpdateRequest, TResponse, TSearchObject> : BaseService<TResponse, TEntity, TSearchObject>, IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TSearchObject> where TEntity: class where TInsertRequest : class where TUpdateRequest : class where TResponse:class where TSearchObject : BaseSearchObject {
    
    public BaseCrudService(MojPrijevozDbContext context, IMapper mapper) : base(context, mapper)
    {
    }

    protected virtual Task BeforeInsert(TInsertRequest request) { return Task.CompletedTask;}
    protected virtual void AfterInsert(TEntity entity) {}
    protected virtual TEntity MapToInsertEntity(TInsertRequest request) => _mapper.Map<TEntity>(request);

    public async Task<TResponse> InsertAsync(TInsertRequest request)
    {
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(MapToInsertEntity(request));
        AfterInsert(entityEntry.Entity);
        await _dbContext.SaveChangesAsync();
        return MapToResponseModel(entityEntry.Entity);
    }

    protected virtual void BeforeUpdate(TUpdateRequest request, TEntity entity) { }
    protected virtual void AfterUpdate(TEntity entity) { }
    protected virtual void MapToUpdateEntity(TUpdateRequest request, TEntity entity) => _mapper.Map(request, entity);

    public async Task<TResponse> UpdateAsync(int id, TUpdateRequest request)
    {
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        BeforeUpdate(request, entity);
        MapToUpdateEntity(request, entity);
        AfterUpdate(entity);
        await _dbContext.SaveChangesAsync();
        return MapToResponseModel(entity);
    }

    protected virtual void BeforeDelete() { }
    protected virtual void AfterDelete() { }

    public async Task DeleteAsync(int id)
    {
        var dbSet = _dbContext.Set<TEntity>();
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        BeforeDelete();
        dbSet.Remove(entity);
        AfterDelete();
        await _dbContext.SaveChangesAsync();
    }
}