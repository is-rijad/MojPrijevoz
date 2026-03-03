using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Model.SearchObjects;

namespace MojPrijevoz.Services.SearchFare;

public class SearchFareService : ISearchFareService
{
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IMapper _mapper;

    public SearchFareService(MojPrijevozDbContext dbContext,
        IMapper mapper)
    {
        _dbContext = dbContext;
        _mapper = mapper;
    }
    public async Task<PagedResult<UserResponse>> Search(SearchFareSearchObject searchObject)
    {
        var newStart = searchObject.FareDateTime;
        var newEnd = searchObject.FareDateTime.AddMinutes(searchObject.Duration);

        var unAvailableDrivers = await _dbContext.Fares.Where(it => it.Status == FareStatus.Accepted)
            .Where(f =>
                f.FareDateTime.AddMinutes(f.Duration) <= newStart
                || f.FareDateTime >= newEnd
            ).Select(it => it.DriverId).ToListAsync();
        var profilesQuery = _dbContext.UserProfiles.Where(it => it.ProfileType == ProfileType.Driver && !unAvailableDrivers.Contains(it.Id)).AsQueryable();

        var fullCount = await profilesQuery.CountAsync();
        profilesQuery = profilesQuery.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        var items = await profilesQuery.Select(it => _mapper.Map<UserResponse>(it.User!)).ToListAsync();
        var count = await profilesQuery.CountAsync();

        return new PagedResult<UserResponse>()
        {
            Count = count,
            HasMore = fullCount > searchObject.Page * searchObject.PageSize,
            Items = items
        };
    }
}