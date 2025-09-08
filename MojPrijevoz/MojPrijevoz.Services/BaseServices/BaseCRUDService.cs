using System.Linq.Expressions;
using Azure;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Database;

namespace MojPrijevoz.Services.BaseServices;

public abstract class BaseCRUDService<TEntity, TInsertRequest, TUpdateRequest, TResponse, TSearchObject> : BaseService<TResponse, TEntity, TSearchObject>, IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TSearchObject> where TEntity: class where TInsertRequest : class where TUpdateRequest : class where TResponse:class where TSearchObject : BaseSearchObject {
    
    public BaseCRUDService(MojPrijevozDbContext context, IMapper mapper) : base(context, mapper)
    {
    }

    protected virtual void BeforeInsert(TInsertRequest request) { }
    protected virtual void AfterInsert(TEntity entity) {}

    public async Task<TResponse> InsertAsync(TInsertRequest request)
    {
        BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(_mapper.Map<TEntity>(request));
        AfterInsert(entityEntry.Entity);
        await _dbContext.SaveChangesAsync();
        return MapToResponseModel(entityEntry.Entity);
    }

    protected virtual void BeforeUpdate(TUpdateRequest request) { }
    protected virtual void AfterUpdate(TEntity entity) { }

    public async Task<TResponse> UpdateAsync(int id, TUpdateRequest request)
    {
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        BeforeUpdate(request);
        _mapper.Map(request, entity);
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