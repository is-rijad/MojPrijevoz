using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.BaseModels.Admin;
using MojPrijevoz.Model.Dtos.BaseService;
using MojPrijevoz.Model.Exceptions;
using System.Linq.Dynamic.Core;

namespace MojPrijevoz.Services.BaseServices.Admin;

public abstract class
    BaseAdminService<TResponse, TAllResponse, TEntity, TSearchObject> : IBaseAdminService<TResponse, TAllResponse, TSearchObject> 
    where TEntity : class
    where TAllResponse : class
    where TResponse : TAllResponse
    where TSearchObject : OrderableSearchObject {
    protected readonly MojPrijevozDbContext _dbContext;
    protected readonly IMapper _mapper;

    public BaseAdminService(MojPrijevozDbContext dbContext, IMapper mapper) {
        _dbContext = dbContext;
        _mapper = mapper;
    }


    public async Task<Model.BaseModels.PagedResult<TAllResponse>> GetAsync(TSearchObject searchObject) {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        queryable = await ApplyFilter(queryable, searchObject);
        queryable = ApplyOrdering(queryable, searchObject);
        var paginatedQueryable = await Paginate(queryable, searchObject);
        queryable = paginatedQueryable.Queryable;
        queryable = await IncludeAdditionalEntities(queryable);
        var list = await queryable.Select(e => MapToResponseModel<TAllResponse>(e, _mapper)).ToListAsync();
        return new Model.BaseModels.PagedResult<TAllResponse>
        {
            Items = list,
            Count = paginatedQueryable.PaginatedCount,
            HasMore = paginatedQueryable.FullCount > searchObject.Page * searchObject.PageSize + searchObject.PageSize
        };
    }

    protected async Task<PaginatedQueryable<TEntity>> Paginate(IQueryable<TEntity> queryable, TSearchObject searchObject) {
        var fullCount = await queryable.CountAsync();
        queryable = queryable.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        return new PaginatedQueryable<TEntity>(queryable, fullCount, await queryable.CountAsync());
    }

    protected virtual IQueryable<TEntity> ApplyOrdering(IQueryable<TEntity> queryable, TSearchObject searchObject) {
        if (!string.IsNullOrEmpty(searchObject.OrderBy))
        {
            var direction = searchObject.OrderDirection == "desc" ? "descending" : "ascending";
            return queryable.OrderBy($"{searchObject.OrderBy} {direction}").AsQueryable();
        }
        return queryable.OrderByDescending(it => EF.Property<int>(it, "Id")).AsQueryable();
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