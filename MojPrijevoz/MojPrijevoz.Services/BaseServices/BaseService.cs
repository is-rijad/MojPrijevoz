using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;

namespace MojPrijevoz.Services.BaseServices;

public abstract class
    BaseService<TResponse, TDetailedResponse, TEntity, TSearchObject> : IBaseService<TResponse, TDetailedResponse,
        TSearchObject> where TResponse : class
    where TDetailedResponse : class
    where TEntity : class
    where TSearchObject : BaseSearchObject
{
    protected readonly MojPrijevozDbContext _dbContext;
    protected readonly IMapper _mapper;

    public BaseService(MojPrijevozDbContext dbContext, IMapper mapper)
    {
        _dbContext = dbContext;
        _mapper = mapper;
    }


    public async Task<PagedResult<TResponse>> GetAsync(TSearchObject searchObject)
    {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        queryable = ApplyFilter(queryable, searchObject);
        var fullCount = await queryable.CountAsync();
        queryable = queryable.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        queryable = await IncludeAdditionalEntities(queryable);
        var list = await queryable.ToListAsync();
        return new PagedResult<TResponse>
        {
            Items = list.Select(MapToResponseModel<TResponse>).ToList(),
            Count = queryable.Count(),
            HasMore = fullCount > searchObject.Page * searchObject.PageSize
        };
    }

    public async Task<TDetailedResponse> GetByIdAsync(int id)
    {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        var entity = await queryable.FirstOrDefaultAsync(e => EF.Property<int>(e, "Id") == id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<TDetailedResponse>(entity);
    }

    public virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> queryable, TSearchObject searchObject)
    {
        return queryable;
    }

    public virtual Task<IQueryable<TEntity>> IncludeAdditionalEntities(IQueryable<TEntity> queryable)
    {
        return Task.FromResult(queryable);
    }

    protected virtual Task PrepareForResponse(TEntity entity, MojPrijevozDbContext dbContext)
    {
        return Task.CompletedTask;
    }

    protected T MapToResponseModel<T>(TEntity entity)
    {
        return _mapper.Map<T>(entity);
    }
}