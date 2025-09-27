using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.BaseServices;

public abstract class
    BaseCrudService<TEntity, TInsertRequest, TUpdateRequest, TResponse, TDetailedResponse, TSearchObject> :
        BaseService<TResponse, TDetailedResponse, TEntity, TSearchObject>,
        IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TDetailedResponse, TSearchObject>
    where TEntity : class
    where TInsertRequest : class
    where TUpdateRequest : class
    where TResponse : class
    where TDetailedResponse : class
    where TSearchObject : BaseSearchObject
{
    protected readonly AuthorizationService _authorizationService;

    public BaseCrudService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) :
        base(context, mapper)
    {
        _authorizationService = authorizationService;
    }

    public async Task<TDetailedResponse> InsertAsync(TInsertRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(MapToInsertEntity(request));
        await _dbContext.SaveChangesAsync();
        await AfterInsert(entityEntry.Entity, _dbContext);
        await transaction.CommitAsync();
        await PrepareForResponse(entityEntry.Entity, _dbContext);
        return MapToResponseModel<TDetailedResponse>(entityEntry.Entity);
    }

    public async Task<TDetailedResponse> UpdateAsync(int id, TUpdateRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await BeforeUpdate(id, request, entity);
        MapToUpdateEntity(request, entity);
        await _dbContext.SaveChangesAsync();
        await AfterUpdate(entity, _dbContext);
        await transaction.CommitAsync();
        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<TDetailedResponse>(entity);
    }

    public async Task DeleteAsync(int id)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var dbSet = _dbContext.Set<TEntity>();
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        BeforeDelete(id, entity);
        dbSet.Remove(entity);
        AfterDelete();
        await transaction.CommitAsync();
        await _dbContext.SaveChangesAsync();
    }

    protected virtual Task BeforeInsert(TInsertRequest request)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterInsert(TEntity entity, MojPrijevozDbContext dbContext)
    {
        return Task.CompletedTask;
    }

    protected virtual TEntity MapToInsertEntity(TInsertRequest request)
    {
        return _mapper.Map<TEntity>(request);
    }

    protected virtual Task BeforeUpdate(int id, TUpdateRequest request, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterUpdate(TEntity entity, MojPrijevozDbContext dbContext)
    {
        return Task.CompletedTask;
    }

    protected virtual void MapToUpdateEntity(TUpdateRequest request, TEntity entity)
    {
        _mapper.Map(request, entity);
    }

    protected virtual Task BeforeDelete(int id, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual void AfterDelete()
    {
    }
}