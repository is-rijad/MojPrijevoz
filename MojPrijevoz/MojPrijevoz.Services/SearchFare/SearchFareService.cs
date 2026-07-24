using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.BaseService;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Model.Responses.SearchFare;
using MojPrijevoz.Model.Responses.UserVehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.OpenRoute;
using System.Globalization;

namespace MojPrijevoz.Services.SearchFare;

public class SearchFareService : ISearchFareService
{
    private readonly AuthorizationService _authorizationService;
    private readonly MojPrijevozDbContext _dbContext;
    private readonly IMapper _mapper;
    private readonly IOpenRouteService _openRouteService;

    public SearchFareService(MojPrijevozDbContext dbContext,
        IMapper mapper, AuthorizationService authorizationService, IOpenRouteService openRouteService)
    {
        _dbContext = dbContext;
        _mapper = mapper;
        _authorizationService = authorizationService;
        _openRouteService = openRouteService;
    }

    public async Task<PagedResult<SearchFareResponse>> Search(SearchFareSearchObject searchObject)
    {
        if (searchObject.Distance < 1) throw new BadRequestException("Distanca ne može biti manja od 1km");

        if (searchObject.FareDateTime < DateTime.UtcNow)
            throw new BadRequestException("Vrijeme vožnje ne može biti u prošlosti!");
        var newStart = searchObject.FareDateTime;
        var newEnd = searchObject.FareDateTime.AddMinutes(searchObject.Duration);
        var profileId = await _authorizationService.GetProfileId(ProfileType.Driver);
        var userId = _authorizationService.GetUserId();
        var passengerCity = (await _dbContext.Users.Include(it => it.City).FirstAsync(it => it.Id == userId)).City!;
        var unAvailableDrivers = await _dbContext.Fares
            .Where(f =>
                f.Status == FareStatus.Accepted &&
                (f.FareStartAfter ?? f.FareData!.FareDateTime.AddMinutes(-30)) < newEnd &&
                f.FareData!.FareDateTime.AddMinutes(f.FareData.Duration) > newStart
            ).Select(it => it.DriverId).ToListAsync();
        var profilesQuery = _dbContext.UserProfiles
            .Where(it =>
                it.ProfileType == ProfileType.Driver && it.Id != profileId && !unAvailableDrivers.Contains(it.Id) &&
                it.UserVehicles!.Any(i => i.Status == UserVehicleStatus.Active) &&
                it.User!.Status == AccountStatus.Active).AsQueryable();

        if (searchObject.DriverId != null)
            profilesQuery = profilesQuery.Where(it => it.Id == searchObject.DriverId.Value);

        var fullCount = await profilesQuery.CountAsync();
        var passLat = Convert.ToDouble(passengerCity.Lat, CultureInfo.InvariantCulture);
        var passLon = Convert.ToDouble(passengerCity.Long, CultureInfo.InvariantCulture);

        var passLatRad = passLat * Math.PI / 180;
        var passLonRad = passLon * Math.PI / 180;
        var toRad = Math.PI / 180;

        var items = await profilesQuery.Select(it => new SearchFareResponse
            {
                Id = it.UserId,
                ProfileId = it.Id,
                FirstName = it.User!.FirstName,
                LastName = it.User!.LastName,
                Picture = it.User!.Picture,

                AverageReview = _dbContext.Ratings.Where(r => r.ToId == it.Id).Average(r => (double?)r.Grade) ?? 0,

                NumberOfReviews = _dbContext.Ratings.Count(r => r.ToId == it.Id),

                Vehicles = it.UserVehicles!.Where(i => i.Status == UserVehicleStatus.Active).AsQueryable()
                    .OrderBy(uv => uv.PricePerKm).Include(uv => uv.Vehicle)
                    .Select(i => _mapper.Map<UserVehicleResponse>(i))
                    .ToList(),

                Distance = Math.Asin(Math.Sqrt(
                    Math.Sin((Convert.ToDouble(it.User!.City!.Lat) - passLat) * toRad / 2) *
                    Math.Sin((Convert.ToDouble(it.User!.City!.Lat) - passLat) * toRad / 2) +
                    Math.Cos(passLatRad) *
                    Math.Cos(Convert.ToDouble(it.User!.City!.Lat) * toRad) *
                    (Math.Sin((Convert.ToDouble(it.User!.City!.Long) - passLon) * toRad / 2) *
                     Math.Sin((Convert.ToDouble(it.User!.City!.Long) - passLon) * toRad / 2))
                )) * 2 * 6371
            }).OrderBy(it => it.Distance)
            .Skip((searchObject.Page - 1) * searchObject.PageSize)
            .Take(searchObject.PageSize)
            .ToListAsync();

        var count = await profilesQuery.CountAsync();

        return new PagedResult<SearchFareResponse>
        {
            Count = count,
            HasMore = fullCount > (searchObject.Page - 1) * searchObject.PageSize + searchObject.PageSize,
            Items = items
        };
    }

    public async Task<SearchFareDriverResponse> SearchDriver(int profileId, SearchFareDriverSearchObject searchObject)
    {
        var driver = await _dbContext.UserProfiles
            .Where(it => it.Id == profileId && it.User!.Status == AccountStatus.Active).FirstOrDefaultAsync();
        if (driver == null) throw new BadRequestException("Korisnik nije pronađen!");

        var driversCityId = await _dbContext.UserProfiles.Where(it => it.Id == profileId).Select(it => it.User!.CityId)
            .FirstAsync();
        var distance = searchObject.Distance;
        var additionalDistance = (await _openRouteService.GetDistance(new GetDistanceRequest
            { CityFrom = driversCityId, CityTo = searchObject.OriginCityId })).DistanceInKm;
        var finalDistance = distance + additionalDistance;

        var driversDiscount = await _dbContext.DriversDiscounts.Where(it =>
                it.MinKm >= finalDistance && (it.MaxKm == null || it.MaxKm <= finalDistance))
            .FirstOrDefaultAsync();
        var userVehicle = await _dbContext.UserVehicles.Where(it => it.Status == UserVehicleStatus.Active)
            .FirstOrDefaultAsync(it => it.Id == searchObject.UserVehicleId);
        if (userVehicle is null) throw new BadRequestException("Vozilo nije pronađeno!");
        var price = Math.Round(
            distance * userVehicle!.PricePerKm * (driversDiscount?.Discount / 100 ?? 1), 2);
        var additionalPrice = Math.Round(
            additionalDistance * userVehicle!.PricePerKm * (driversDiscount?.Discount / 100 ?? 1), 2);

        return new SearchFareDriverResponse
        {
            Id = profileId,
            Price = price,
            VehicleId = userVehicle.VehicleId,
            UserVehicleId = userVehicle.Id,
            AdditionalPrice = additionalPrice == 0 ? null : additionalPrice
        };
    }
}