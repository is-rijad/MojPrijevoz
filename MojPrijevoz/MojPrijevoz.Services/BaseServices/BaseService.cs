using System.Linq.Expressions;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Database;

namespace MojPrijevoz.Services.BaseServices;

public abstract class BaseService<TResponse, TEntity, TSearchObject> : IBaseService<TResponse, TSearchObject> where TResponse : class where TEntity : class where TSearchObject : BaseSearchObject {
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IMapper _mapper;

    public BaseService(MojPrijevozDbContext dbContext, IMapper mapper)
    {
        _dbContext = dbContext;
        _mapper = mapper;
    }

    public virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> queryable, TSearchObject searchObject)
    {
        return queryable;
    }

    public async Task<PagedResult<TResponse>> GetAsync(TSearchObject searchObject)
    {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        queryable = ApplyFilter(queryable, searchObject);
        queryable = queryable.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        var list = await queryable.ToListAsync();
        return new PagedResult<TResponse>
        {
            Items = list.Select(MapToResponseModel).ToList(),
            Count = queryable.Count()
        };
    }

    public async Task<TResponse> GetByIdAsync(int id)
    {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        var entity = await queryable.FirstOrDefaultAsync(e => EF.Property<int>(e, "Id") == id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        return MapToResponseModel(entity);
    }

    private TResponse MapToResponseModel(TEntity entity)
    {
        return _mapper.Map<TResponse>(entity);
    }
}