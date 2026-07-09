using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.Recommender;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Recommender.Helpers;
using MojPrijevoz.Recommender.Models;
using MojPrijevoz.Recommender.Pool;
using MojPrijevoz.Services.Authorization;
using System.Text.Json;
using MojPrijevoz.Database.Interfaces;
using MojPrijevoz.Recommender.Dtos;

namespace MojPrijevoz.Recommender;

public class RecommenderService {
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly MLContext _mlContext;
    private readonly RecommenderPredictionPool _pool;

    private ITransformer? _model;
    private RouteIndex _routeIndex = new();

    private Dictionary<int, int> _driverFareCounts = new();
    private Dictionary<int, List<int>> _driversByOriginCity = new();
    
    private static string DataDir => Environment.GetEnvironmentVariable("Recommender__DataDir") ??
                                       throw new ArgumentException("Recommender__DataDir is not set!");

    private static string ModelPath => DataDir + Environment.GetEnvironmentVariable("Recommender__ModelPath") ??
                                       throw new ArgumentException("Recommender__ModelPath is not set!");
    private static string IndexPath => DataDir + Environment.GetEnvironmentVariable("Recommender__IndexPath") ??
                                       throw new ArgumentException("Recommender__IndexPath is not set!");


    public RecommenderService(
        IServiceScopeFactory scopeFactory,
        MLContext mlContext,
        RecommenderPredictionPool pool) {
        _scopeFactory = scopeFactory;
        _mlContext = mlContext;
        _pool = pool;
    }

    public async Task TrainAsync() {
        await using var scope = _scopeFactory.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();

        _routeIndex = new RouteIndex();

        var completedFares = await db.Fares
            .Where(f => f.Status == FareStatus.Completed)
            .Include(f => f.FareData)
            .ToListAsync();

        if (!completedFares.Any()) return;

        var interactions = completedFares
            .GroupBy(f => new
            {
                f.PassengerId,
                RouteKey = $"{f.FareData!.OriginCityId}→{f.FareData.DestinationZone}"
            })
            .Select(g => new PassengerRouteInteraction
            {
                PassengerId = (uint)g.Key.PassengerId,
                RouteId = _routeIndex.GetOrAdd(g.Key.RouteKey),
                Label = g.Count()
            })
            .ToList();

        _driverFareCounts = completedFares
            .GroupBy(f => f.DriverId)
            .ToDictionary(g => g.Key, g => g.Count());

        _driversByOriginCity = completedFares
            .GroupBy(f => f.FareData!.OriginCityId)
            .ToDictionary(
                g => g.Key,
                g => g.Select(f => f.DriverId).Distinct().ToList());

        var data = _mlContext.Data.LoadFromEnumerable(interactions);

        var options = new MatrixFactorizationTrainer.Options
        {
            MatrixColumnIndexColumnName = nameof(PassengerRouteInteraction.PassengerId),
            MatrixRowIndexColumnName = nameof(PassengerRouteInteraction.RouteId),
            LabelColumnName = nameof(PassengerRouteInteraction.Label),
            NumberOfIterations = 20,
            ApproximationRank = 32,
            LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
            Alpha = 0.01,
            C = 0.001
        };

        var pipeline = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
        _model = pipeline.Fit(data);
        _pool.Initialize(_model);

        _mlContext.Model.Save(_model, null, ModelPath);
        await File.WriteAllTextAsync(IndexPath, JsonSerializer.Serialize(_routeIndex.GetMap()));
    }

    public async Task LoadOrTrainAsync() {
        if (!Directory.Exists(DataDir))
        {
            Directory.CreateDirectory(DataDir);
        }
        if (File.Exists(ModelPath) && File.Exists(IndexPath)) {
            _model = _mlContext.Model.Load(ModelPath, out _);

            var json = await File.ReadAllTextAsync(IndexPath);
            var map = JsonSerializer.Deserialize<Dictionary<string, uint>>(json)!;
            _routeIndex.LoadFrom(map);

            _pool.Initialize(_model);

            using var scope = _scopeFactory.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();

            var completedFares = await db.Fares
                .Where(f => f.Status == FareStatus.Completed)
                .Include(f => f.FareData)
                .ToListAsync();

            _driverFareCounts = completedFares
                .GroupBy(f => f.DriverId)
                .ToDictionary(g => g.Key, g => g.Count());

            _driversByOriginCity = completedFares
                .GroupBy(f => f.FareData!.OriginCityId)
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(f => f.DriverId).Distinct().ToList());
        }
        else {
            await TrainAsync();
        }
    }

    public async Task<PagedResult<RecommendedDriverRouteResponse>> RecommendDriversAsync(RecommendedDriversSearchObject searchObject) {
        await using var scope = _scopeFactory.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();
        var authService = scope.ServiceProvider.GetRequiredService<AuthorizationService>();
        var passengerId = await authService.GetProfileId(ProfileType.Passenger);
        var driverId = await authService.GetProfileId(ProfileType.Driver);

        var popularDriversDto = new PopularDriversDto() { DriverId = driverId, Database = db, SearchObject = searchObject };
        if (_model is null)
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var knownRouteKeys = await db.Fares
            .Where(f => f.PassengerId == passengerId && f.Status == FareStatus.Completed)
            .Include(f => f.FareData)
            .Select(f => $"{f.FareData!.OriginCityId}→{f.FareData.DestinationZone}")
            .Distinct()
            .ToListAsync();

        if (!knownRouteKeys.Any())
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var unseenRoutes = _routeIndex.GetMap().Keys
            .Except(knownRouteKeys)
            .ToList();

        if (!unseenRoutes.Any())
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var predEngine = _pool.GetPredictionEngine();
        try {
            var topRouteKeys = unseenRoutes
                .Select(routeKey => new RouteKeyDto()
                {
                    RouteKey = routeKey,
                    Score = predEngine.Predict(new PassengerRouteInteraction
                    {
                        PassengerId = (uint)passengerId!,
                        RouteId = _routeIndex.Get(routeKey)!.Value
                    }).Score
                })
                .OrderByDescending(x => x.Score)
                .Take(5)
                .Select(x => x.RouteKey)
                .ToList();
            return await BuildResultAsync(new BuildResultDto(popularDriversDto) { RouteKeys = topRouteKeys });
        }
        finally {
            _pool.Return(predEngine);
        }

    }

    private async Task<PagedResult<RecommendedDriverRouteResponse>> BuildResultAsync(
       BuildResultDto dto) {
        var queryable = dto.Database.Fares
            .Where(f => f.Status == FareStatus.Completed
                        && dto.RouteKeys.Contains(
                            f.FareData!.OriginCityId + "→" + f.FareData.DestinationZone) && (dto.DriverId == null || f.DriverId != dto.DriverId))
            .AsQueryable();

        var items = await queryable
            .GroupBy(f => new { f.DriverId, f.FareData!.DestinationZone, f.FareData.OriginCityId })
            .Select(g => new RecommendedDriverRouteResponse
            {
                Id = g.Key.DriverId,
                FirstName = g.First().Driver!.User!.FirstName,
                LastName = g.First().Driver!.User!.LastName,
                Picture = g.First().Driver!.User!.GetPicture(),
                AverageRating = dto.Database.Ratings
                    .Where(r => r.ToId == g.Key.DriverId)
                    .Average(r => (double?)r.Grade) ?? 0,
                OriginCityName = g.First().FareData!.OriginCity!.Name,
                DestinationName = g.First().FareData!.DestinationName,
                RidesCount = g.Count(),
                Status = g.First().Driver!.User!.Status
            })
            .OrderByDescending(x => x.RidesCount)
            .Skip((dto.SearchObject.Page - 1) * dto.SearchObject.PageSize)
            .Take(dto.SearchObject.PageSize)
            .ToListAsync();
        var fullCount = await queryable.CountAsync();

        return new PagedResult<RecommendedDriverRouteResponse>
        {
            Items = items,
            Count = items.Count,
            HasMore = fullCount > (dto.SearchObject.Page - 1) * dto.SearchObject.PageSize + dto.SearchObject.PageSize
        };
    }

    private async Task<PagedResult<RecommendedDriverRouteResponse>> PopularRoutesWithDriversAsync(PopularDriversDto dto)
    {
        var popularRouteKeys = await dto.Database.Fares
            .Where(f => f.Status == FareStatus.Completed && (dto.DriverId == null || dto.DriverId != f.DriverId))
            .GroupBy(f => new
            {
                f.FareData!.OriginCityId,
                f.FareData.DestinationZone
            })
            .OrderByDescending(g => g.Count())
            .Take(5)
            .Select(g => $"{g.Key.OriginCityId}→{g.Key.DestinationZone}")
            .ToListAsync();

        return await BuildResultAsync(new BuildResultDto(dto) {RouteKeys = popularRouteKeys});
    }
}