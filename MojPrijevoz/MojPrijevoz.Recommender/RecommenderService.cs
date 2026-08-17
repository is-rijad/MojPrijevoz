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
    private RouteIndex _passengerIndex = new();
    private HashSet<int> _trainedPassengerIds = new();

    private static string DataDir => Environment.GetEnvironmentVariable("Recommender__DataDir") ??
                                       throw new ArgumentException("Recommender__DataDir is not set!");

    private static string ModelPath => DataDir + (Environment.GetEnvironmentVariable("Recommender__ModelPath") ??
                                       throw new ArgumentException("Recommender__ModelPath is not set!"));
    private static string IndexPath => DataDir + (Environment.GetEnvironmentVariable("Recommender__IndexPath") ??
                                       throw new ArgumentException("Recommender__IndexPath is not set!"));

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

        var completedFares = await db.Fares
            .Where(f => f.Status == FareStatus.Completed)
            .Select(f => new
            {
                f.PassengerId,
                f.FareData!.OriginCityId,
                f.FareData.DestinationZone
            })
            .ToListAsync();

        if (completedFares.Count == 0) return;

        var newRouteIndex = new RouteIndex();
        var newPassengerIndex = new RouteIndex();
        var trainedPassengerIds = new HashSet<int>();

        var interactions = completedFares
            .GroupBy(f => new { f.PassengerId, RouteKey = $"{f.OriginCityId}→{f.DestinationZone}" })
            .Select(g => {
                trainedPassengerIds.Add(g.Key.PassengerId);
                return new PassengerRouteInteraction
                {
                    PassengerId = newPassengerIndex.GetOrAdd(g.Key.PassengerId.ToString()),
                    RouteId = newRouteIndex.GetOrAdd(g.Key.RouteKey),
                    Label = 1f
                };
            })
            .ToList();

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
        var newModel = pipeline.Fit(data);

        _mlContext.Model.Save(newModel, data.Schema, ModelPath);
        await File.WriteAllTextAsync(IndexPath, JsonSerializer.Serialize(new PersistedIndexes
        {
            Routes = newRouteIndex.GetMap(),
            Passengers = newPassengerIndex.GetMap()
        }));

        _pool.Initialize(newModel);
        _routeIndex = newRouteIndex;
        _passengerIndex = newPassengerIndex;
        _trainedPassengerIds = trainedPassengerIds;
        _model = newModel;
    }

    public async Task LoadOrTrainAsync() {
        if (!Directory.Exists(DataDir))
            Directory.CreateDirectory(DataDir);

        if (!File.Exists(ModelPath) || !File.Exists(IndexPath)) {
            await TrainAsync();
            return;
        }

        var loadedModel = _mlContext.Model.Load(ModelPath, out _);

        var json = await File.ReadAllTextAsync(IndexPath);
        var persisted = JsonSerializer.Deserialize<PersistedIndexes>(json)!;

        var loadedRouteIndex = new RouteIndex();
        loadedRouteIndex.LoadFrom(persisted.Routes);

        var loadedPassengerIndex = new RouteIndex();
        loadedPassengerIndex.LoadFrom(persisted.Passengers);

        _pool.Initialize(loadedModel);
        _routeIndex = loadedRouteIndex;
        _passengerIndex = loadedPassengerIndex;
        _trainedPassengerIds = persisted.Passengers.Keys.Select(int.Parse).ToHashSet();
        _model = loadedModel;
    }

    public async Task<PagedResult<RecommendedDriverRouteResponse>> RecommendDriversAsync(RecommendedDriversSearchObject searchObject) {
        await using var scope = _scopeFactory.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<MojPrijevozDbContext>();
        var authService = scope.ServiceProvider.GetRequiredService<AuthorizationService>();
        var passengerId = await authService.GetProfileId(ProfileType.Passenger);
        var driverId = await authService.GetProfileId(ProfileType.Driver);

        var popularDriversDto = new PopularDriversDto { DriverId = driverId, Database = db, SearchObject = searchObject };

        var model = _model;
        var routeIndex = _routeIndex;
        var passengerIndex = _passengerIndex;
        var trainedPassengerIds = _trainedPassengerIds;

        if (model is null || passengerId is null || !trainedPassengerIds.Contains(passengerId.Value))
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var knownRouteKeys = await db.Fares
            .Where(f => f.PassengerId == passengerId && f.Status == FareStatus.Completed)
            .Include(f => f.FareData)
            .Select(f => $"{f.FareData!.OriginCityId}→{f.FareData.DestinationZone}")
            .Distinct()
            .ToListAsync();

        var unseenRoutes = routeIndex.GetMap().Keys
            .Except(knownRouteKeys)
            .ToList();

        if (unseenRoutes.Count == 0)
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var passengerKey = passengerIndex.Get(passengerId.Value.ToString());
        if (passengerKey is null)
            return await PopularRoutesWithDriversAsync(popularDriversDto);

        var predEngine = _pool.GetPredictionEngine();
        Dictionary<string, float> routeScores;
        try {
            routeScores = unseenRoutes.ToDictionary(
                routeKey => routeKey,
                routeKey => predEngine.Predict(new PassengerRouteInteraction
                {
                    PassengerId = passengerKey.Value,
                    RouteId = routeIndex.Get(routeKey)!.Value
                }).Score);
        }
        finally {
            _pool.Return(predEngine);
        }

        var topRouteKeys = routeScores
            .OrderByDescending(kv => kv.Value)
            .Take(5)
            .Select(kv => kv.Key)
            .ToList();

        return await BuildResultAsync(new BuildResultDto(popularDriversDto)
        {
            RouteKeys = topRouteKeys,
            RouteScores = routeScores
        });
    }

    private async Task<PagedResult<RecommendedDriverRouteResponse>> BuildResultAsync(BuildResultDto dto) {
        var queryable = dto.Database.Fares
            .Where(f => f.Status == FareStatus.Completed
                        && dto.RouteKeys.Contains(f.FareData!.OriginCityId + "→" + f.FareData.DestinationZone)
                        && (dto.DriverId == null || f.DriverId != dto.DriverId));

        var grouped = queryable.GroupBy(f => new { f.DriverId, f.FareData!.DestinationZone, f.FareData.OriginCityId });


        var materialized = await grouped.Select(g => new
        {
            RouteKey = g.Key.OriginCityId + "→" + g.Key.DestinationZone,
            Response = new RecommendedDriverRouteResponse
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
            }
        }).ToListAsync();

        var ordered = dto.RouteScores is { Count: > 0 }
            ? materialized
                .OrderByDescending(x => dto.RouteScores!.GetValueOrDefault(x.RouteKey, float.MinValue))
                .ThenByDescending(x => x.Response.RidesCount)
            : materialized.OrderByDescending(x => x.Response.RidesCount);

        var fullCount = materialized.Count;

        var items = ordered
            .Skip((dto.SearchObject.Page - 1) * dto.SearchObject.PageSize)
            .Take(dto.SearchObject.PageSize)
            .Select(x => x.Response)
            .ToList();

        return new PagedResult<RecommendedDriverRouteResponse>
        {
            Items = items,
            Count = fullCount,
            HasMore = fullCount > (dto.SearchObject.Page - 1) * dto.SearchObject.PageSize + dto.SearchObject.PageSize
        };
    }

    private async Task<PagedResult<RecommendedDriverRouteResponse>> PopularRoutesWithDriversAsync(PopularDriversDto dto) {
        var popularRouteKeys = await dto.Database.Fares
            .Where(f => f.Status == FareStatus.Completed && (dto.DriverId == null || dto.DriverId != f.DriverId))
            .GroupBy(f => new { f.FareData!.OriginCityId, f.FareData.DestinationZone })
            .OrderByDescending(g => g.Count())
            .Take(5)
            .Select(g => $"{g.Key.OriginCityId}→{g.Key.DestinationZone}")
            .ToListAsync();

        return await BuildResultAsync(new BuildResultDto(dto) { RouteKeys = popularRouteKeys });
    }
}