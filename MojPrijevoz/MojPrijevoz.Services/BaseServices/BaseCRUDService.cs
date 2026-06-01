using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Database.Interfaces;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.FormRequests;

namespace MojPrijevoz.Services.BaseServices;

public abstract class
    BaseCrudService<TEntity, TInsertRequest, TUpdateRequest, TResponse, TSearchObject> :
        BaseService<TResponse, TEntity, TSearchObject>,
        IBaseCRUDService<TInsertRequest, TUpdateRequest, TResponse, TSearchObject>
    where TEntity : class
    where TInsertRequest : class
    where TUpdateRequest : class
    where TResponse : class
    where TSearchObject : BaseSearchObject {
    protected readonly AuthorizationService _authorizationService;
    private readonly IFileStorageService? _fileStorageService;

    public BaseCrudService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, IFileStorageService? fileStorageService = null) :
        base(context, mapper) {
        _authorizationService = authorizationService;
        _fileStorageService = fileStorageService;
    }

    public virtual async Task<TResponse> InsertWithTransactionAsync(TInsertRequest request) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var response = await InsertAsync(request);
        await transaction.CommitAsync();
        return response;
    }

    public virtual async Task<TResponse> InsertAsync(TInsertRequest request) {
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Set<TEntity>().AddAsync(MapToInsertEntity(request));
        await SetNewAndDeleteOldImageIfNeeded(request, entityEntry.Entity);

        await _dbContext.SaveChangesAsync();
        await AfterInsert(entityEntry.Entity, _dbContext);
        await PrepareForResponse(entityEntry.Entity, _dbContext);
        return MapToResponseModel<TResponse>(entityEntry.Entity, _mapper);
    }

    public virtual async Task<TResponse> UpdateWithTransactionAsync(int id, TUpdateRequest request) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var response = await UpdateAsync(id, request);
        await transaction.CommitAsync();
        return response;
    }

    public virtual async Task<TResponse> UpdateAsync(int id, TUpdateRequest request) {
        var entity = await _dbContext.Set<TEntity>().FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await BeforeUpdate(id, request, entity);


        await SetNewAndDeleteOldImageIfNeeded(request, entity);
        MapToUpdateEntity(request, entity);

        await _dbContext.SaveChangesAsync();
        await AfterUpdate(entity, _dbContext);
        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<TResponse>(entity, _mapper);
    }

    private async Task SetNewAndDeleteOldImageIfNeeded<T>(T request, TEntity entity)
    {
        if (request is not IFormHasPicture imageRequest 
            || imageRequest.Picture is null 
            || _fileStorageService is null) 
            return;
        if (entity is not IEntityHasPicture entityWithPicture)
            throw new Exception("Entity is not IEntityHasPicture!");

        var imagePath = await _fileStorageService.SaveAsync(imageRequest.Picture);

        var value = entityWithPicture.Picture;

        if (!string.IsNullOrEmpty(value))
            await _fileStorageService.DeleteAsync(value);

        entityWithPicture.Picture = imagePath;
    }

    public async Task DeleteAsync(int id) {
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

    protected virtual Task BeforeInsert(TInsertRequest request) {
        return Task.CompletedTask;
    }

    protected virtual Task AfterInsert(TEntity entity, MojPrijevozDbContext dbContext) {
        return Task.CompletedTask;
    }

    protected virtual TEntity MapToInsertEntity(TInsertRequest request) {
        return _mapper.Map<TEntity>(request);
    }

    protected virtual Task BeforeUpdate(int id, TUpdateRequest request, TEntity entity) {
        return Task.CompletedTask;
    }

    protected virtual Task AfterUpdate(TEntity entity, MojPrijevozDbContext dbContext) {
        return Task.CompletedTask;
    }

    protected virtual TEntity MapToUpdateEntity(TUpdateRequest request, TEntity entity) {
        return _mapper.Map(request, entity);
    }

    protected virtual Task BeforeDelete(int id, TEntity entity) {
        return Task.CompletedTask;
    }

    protected virtual void AfterDelete() {
    }
}