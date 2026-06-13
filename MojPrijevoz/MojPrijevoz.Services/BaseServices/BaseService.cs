using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.BaseService;
using MojPrijevoz.Model.Exceptions;

namespace MojPrijevoz.Services.BaseServices;

public abstract class
    BaseService<TResponse, TEntity, TSearchObject> : IBaseService<TResponse, TSearchObject> where TResponse : class
    where TEntity : class
    where TSearchObject : BaseSearchObject {
    protected readonly MojPrijevozDbContext _dbContext;
    protected readonly IMapper _mapper;

    public BaseService(MojPrijevozDbContext dbContext, IMapper mapper) {
        _dbContext = dbContext;
        _mapper = mapper;
    }


    public async Task<PagedResult<TResponse>> GetAsync(TSearchObject searchObject) {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        queryable = await ApplyFilter(queryable, searchObject);
        queryable = await ApplyOrdering(queryable, searchObject);
        var paginatedQueryable = await Paginate(queryable, searchObject);
        queryable = paginatedQueryable.Queryable;
        queryable = await IncludeAdditionalEntities(queryable);
        var list = await queryable.Select(e => MapToResponseModel<TResponse>(e, _mapper)).ToListAsync();
        return new PagedResult<TResponse>
        {
            Items = list,
            Count = paginatedQueryable.PaginatedCount,
            HasMore = paginatedQueryable.FullCount > searchObject.Page * searchObject.PageSize
        };
    }

    protected async Task<PaginatedQueryable<TEntity>> Paginate(IQueryable<TEntity> queryable, TSearchObject searchObject) {
        var fullCount = await queryable.CountAsync();
        queryable = queryable.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        return new PaginatedQueryable<TEntity>(queryable, fullCount, await queryable.CountAsync());
    }

    protected virtual Task<IQueryable<TEntity>> ApplyOrdering(IQueryable<TEntity> queryable, TSearchObject searchObject) {
        return Task.FromResult(queryable);
    }

    public async Task<TResponse> GetByIdAsync(int id) {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        var entity = await queryable.FirstOrDefaultAsync(e => EF.Property<int>(e, "Id") == id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<TResponse>(entity, _mapper);
    }

    public virtual Task<IQueryable<TEntity>> ApplyFilter(IQueryable<TEntity> queryable,
        TSearchObject searchObject) {
        return Task.FromResult(queryable);
    }

    public virtual Task<IQueryable<TEntity>> IncludeAdditionalEntities(IQueryable<TEntity> queryable) {
        return Task.FromResult(queryable);
    }

    protected virtual Task PrepareForResponse(TEntity entity, MojPrijevozDbContext dbContext) {
        return Task.CompletedTask;
    }

    protected static T MapToResponseModel<T>(TEntity entity, IMapper mapper) {
        return mapper.Map<T>(entity);
    }
}