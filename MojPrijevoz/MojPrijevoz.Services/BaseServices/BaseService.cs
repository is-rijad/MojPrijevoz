using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using System.Linq.Expressions;

namespace MojPrijevoz.Services.BaseServices;

public abstract class BaseService<TResponse, TDetailedResponse, TEntity, TSearchObject> : IBaseService<TResponse, TDetailedResponse, TSearchObject> where TResponse : class where TDetailedResponse : class where TEntity : class where TSearchObject : BaseSearchObject {
    protected readonly MojPrijevozDbContext _dbContext;
    protected readonly IMapper _mapper;

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
            Items = list.Select(MapToResponseModel<TResponse>).ToList(),
            Count = queryable.Count()
        };
    }

    public async Task<TDetailedResponse> GetByIdAsync(int id)
    {
        var queryable = _dbContext.Set<TEntity>().AsNoTracking();
        var entity = await queryable.FirstOrDefaultAsync(e => EF.Property<int>(e, "Id") == id);
        if (entity == null)
            throw new NotFoundException($"Nije pronađeno!");
        return MapToResponseModel<TDetailedResponse>(entity);
    }

    protected T MapToResponseModel<T>(TEntity entity)
    {
        return _mapper.Map<T>(entity);
    }
}