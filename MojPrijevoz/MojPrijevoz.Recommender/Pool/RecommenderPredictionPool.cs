using Microsoft.Extensions.ObjectPool;
using Microsoft.ML;
using MojPrijevoz.Recommender.Models;

namespace MojPrijevoz.Recommender.Pool;

public class RecommenderPredictionPool
{
    private readonly object _lock = new();
    private readonly MLContext _mlContext;
    private ObjectPool<PredictionEngine<PassengerRouteInteraction, RoutePrediction>>? _pool;

    public RecommenderPredictionPool(MLContext mlContext)
    {
        _mlContext = mlContext;
    }

    public void Initialize(ITransformer model)
    {
        lock (_lock)
        {
            var policy = new PredictionEnginePoolPolicy<PassengerRouteInteraction, RoutePrediction>(
                _mlContext, model);
            _pool = new DefaultObjectPool<PredictionEngine<PassengerRouteInteraction, RoutePrediction>>(policy);
        }
    }

    public PredictionEngine<PassengerRouteInteraction, RoutePrediction> GetPredictionEngine()
    {
        if (_pool is null)
            throw new InvalidOperationException("Pool nije inicijalizovan.");
        return _pool.Get();
    }

    public void Return(PredictionEngine<PassengerRouteInteraction, RoutePrediction> engine)
    {
        _pool?.Return(engine);
    }
}