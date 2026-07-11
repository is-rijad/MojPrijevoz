using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.Admin.Stats;

namespace MojPrijevoz.Services.Admin;

public class AdminStatsService
{
    private readonly MojPrijevozDbContext _dbContext;

    public AdminStatsService(MojPrijevozDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<PagedResult<AdminUsersByCityResponse>> GetUsersByCityAsync()
    {
        var items = await _dbContext.Users
            .Include(it => it.City)
            .GroupBy(it => new { it.City!.Name, it.City.Lat, it.City.Long })
            .Select(g => new AdminUsersByCityResponse()
            {
                CityName = g.Key.Name,
                Lat = g.Key.Lat,
                Long = g.Key.Long,
                UsersCount = g.Count()
            })
            .ToListAsync();
        return new PagedResult<AdminUsersByCityResponse>()
        {
            Items = items,
            Count = items.Count,
            HasMore = false
        };
    }

    public async Task<PagedResult<BaseResponseByMonth>> GetUsersByMonthAsync() {
        var items = await _dbContext.Users
            .GroupBy(it => new { it.RegisteredAt.Month, it.RegisteredAt.Year })
            .Select(g => new BaseResponseByMonth()
            {
                Month = g.Key.Month,
                Year = g.Key.Year,
                Result = g.Count()
            })
            .OrderBy(it => it.Year).ThenBy(it => it.Month)
            .ToListAsync();
        return new PagedResult<BaseResponseByMonth>()
        {
            Items = items,
            Count = items.Count,
            HasMore = false
        };
    }

    public async Task<PagedResult<BaseResponseByMonth>> GetRevenueByMonthAsync() {
        var items = await _dbContext.Transactions
            .GroupBy(it => new { it.CreatedAt.Month, it.CreatedAt.Year })
            .Select(g => new BaseResponseByMonth()
            {
                Month = g.Key.Month,
                Year = g.Key.Year,
                Result = g.Sum(it => it.FeeAmount) ?? 0
            })
            .OrderBy(it => it.Year).ThenBy(it => it.Month)
            .ToListAsync();
        return new PagedResult<BaseResponseByMonth>()
        {
            Items = items,
            Count = items.Count,
            HasMore = false
        };
    }

    public async Task<PagedResult<FaresThisMonthResponse>> GetAllFaresThisMonthAsync() {
        var items = await _dbContext.Fares
            .Where(it => it.CreatedAt.Month == DateTime.UtcNow.Month && it.CreatedAt.Year == DateTime.UtcNow.Year)
            .GroupBy(it => new { it.Status })
            .Select(g => new FaresThisMonthResponse()
            {
                Status = g.Key.Status,
                Count = g.Count()
            })
            .ToListAsync();
        return new PagedResult<FaresThisMonthResponse>()
        {
            Items = items,
            Count = items.Count,
            HasMore = false
        };
    }
}