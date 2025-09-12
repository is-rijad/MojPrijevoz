using MapsterMapper;
using Microsoft.AspNetCore.Http;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.BaseServices;

public abstract class BaseCrudService<TEntity, TInsertRequest, TUpdateRequest, TResponse, TSearchObject> : BaseService<TResponse, TEntity, TSearchObject>, IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TSearchObject> where TEntity: class where TInsertRequest : class where TUpdateRequest : class where TResponse:class where TSearchObject : BaseSearchObject {
    protected readonly IAuthorizationService _authorizationService;

    public BaseCrudService(MojPrijevozDbContext context, IMapper mapper, IAuthorizationService authorizationService) : base(context, mapper)
    {
        _authorizationService = authorizationService;
    }

    protected virtual Task BeforeInsert(TInsertRequest request) { return Task.CompletedTask;}
    protected virtual void AfterInsert(TEntity entity) {}
    protected virtual TEntity MapToInsertEntity(TInsertRequest request) => _mapper.Map<TEntity>(request);

    public async Task<TResponse> InsertAsync(TInsertRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(MapToInsertEntity(request));
        AfterInsert(entityEntry.Entity);
        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        return MapToResponseModel(entityEntry.Entity);
    }

    protected virtual Task BeforeUpdate(int id, TUpdateRequest request, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual void AfterUpdate(TEntity entity) { }
    protected virtual void MapToUpdateEntity(TUpdateRequest request, TEntity entity) => _mapper.Map(request, entity);

    public async Task<TResponse> UpdateAsync(int id, TUpdateRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        await BeforeUpdate(id, request, entity);
        MapToUpdateEntity(request, entity);
        AfterUpdate(entity);
        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        return MapToResponseModel(entity);
    }

    protected virtual void BeforeDelete(int id) { }
    protected virtual void AfterDelete() { }

    public async Task DeleteAsync(int id)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var dbSet = _dbContext.Set<TEntity>();
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        BeforeDelete(id);
        dbSet.Remove(entity);
        AfterDelete();
        await transaction.CommitAsync();
        await _dbContext.SaveChangesAsync();
    }
}