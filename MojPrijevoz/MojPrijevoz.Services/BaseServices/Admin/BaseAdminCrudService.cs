using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels.Admin;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.RequestChanges;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.BaseServices.Admin;

public abstract class
    BaseAdminCrudService<TEntity, TInsertRequest, TUpdateRequest, TRequestChangesEntity, TResponse, TAllResponse,
        TSearchObject> :
    BaseAdminService<TResponse, TAllResponse, TEntity, TSearchObject>,
    IBaseAdminCRUDService<TInsertRequest, TUpdateRequest, TRequestChangesEntity, TResponse, TAllResponse, TSearchObject>
    where TEntity : class
    where TInsertRequest : class
    where TUpdateRequest : class
    where TRequestChangesEntity : BaseRequestChanges
    where TAllResponse : class
    where TResponse : TAllResponse
    where TSearchObject : OrderableSearchObject
{
    protected readonly AuthorizationService _authorizationService;

    public BaseAdminCrudService(MojPrijevozDbContext context, IMapper mapper,
        AuthorizationService authorizationService) :
        base(context, mapper)
    {
        _authorizationService = authorizationService;
    }

    public virtual async Task<TResponse> InsertWithTransactionAsync(TInsertRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var response = await InsertAsync(request);
        await transaction.CommitAsync();
        return response;
    }

    public virtual async Task<TResponse> InsertAsync(TInsertRequest request)
    {
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(MapToInsertEntity(request));

        await AfterInsert(entityEntry.Entity, request, _dbContext);
        await _dbContext.SaveChangesAsync();

        await PrepareForResponse(entityEntry.Entity, _dbContext);

        return MapToResponseModel<TResponse>(entityEntry.Entity, _mapper);
    }

    public virtual async Task<TResponse> UpdateWithTransactionAsync(int id, TUpdateRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var response = await UpdateAsync(id, request);
        await transaction.CommitAsync();
        return response;
    }

    public virtual async Task<TResponse> RequestChangesAsync(int id, RequestChangesRequest request)
    {
        await BeforeRequestChanges(id);

        var entities = MapToRequestChangesEntity(id, request);
        await _dbContext.Set<TRequestChangesEntity>().AddRangeAsync(entities);
        await SetEntityStatusToWaitingForChanges(id);
        await _dbContext.SaveChangesAsync();
        await SendNotificationEmail(entities);
        return await GetByIdAsync(id);
    }

    public virtual async Task<TResponse> UpdateAsync(int id, TUpdateRequest request)
    {
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await BeforeUpdate(id, request, entity);


        MapToUpdateEntity(request, entity);

        await AfterUpdate(entity, _dbContext);
        await _dbContext.SaveChangesAsync();

        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<TResponse>(entity, _mapper);
    }


    public async Task DeleteAsync(int id)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var dbSet = _dbContext.Set<TEntity>();
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await BeforeDelete(id, entity);
        dbSet.Remove(entity);
        AfterDelete();
        await transaction.CommitAsync();
        await _dbContext.SaveChangesAsync();
    }

    public List<TRequestChangesEntity> MapToRequestChangesEntity(int id, RequestChangesRequest request)
    {
        var list = new List<TRequestChangesEntity>();
        if (request.Notes != null)
            foreach (var note in request.Notes)
            {
                var entity = Activator.CreateInstance<TRequestChangesEntity>();
                entity.Field = note.Key;
                entity.Note = note.Value;
                entity = MapIdToRequestChanges(id, entity);
                list.Add(entity);
            }

        foreach (var item in request.SelectedItems.Where(it => !list.Select(i => i.Field).Contains(it)))
        {
            var entity = Activator.CreateInstance<TRequestChangesEntity>();
            entity.Field = item;
            entity = MapIdToRequestChanges(id, entity);
            list.Add(entity);
        }

        return list;
    }

    public abstract Task BeforeRequestChanges(int id);
    public abstract Task SetEntityStatusToWaitingForChanges(int id);
    public abstract TRequestChangesEntity MapIdToRequestChanges(int id, TRequestChangesEntity entity);
    public abstract Task SendNotificationEmail(List<TRequestChangesEntity> entities);

    protected virtual Task BeforeInsert(TInsertRequest request)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterInsert(TEntity entity, TInsertRequest request, MojPrijevozDbContext dbContext)
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

    protected virtual TEntity MapToUpdateEntity(TUpdateRequest request, TEntity entity)
    {
        return _mapper.Map(request, entity);
    }

    protected virtual Task BeforeDelete(int id, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual void AfterDelete()
    {
    }
}