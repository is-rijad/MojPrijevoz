using Microsoft.ML;
using Microsoft.Extensions.ObjectPool;
using MojPrijevoz.Recommender.Models;

namespace MojPrijevoz.Recommender.Pool;

public class RecommenderPredictionPool {
    private readonly MLContext _mlContext;
    private ObjectPool<PredictionEngine<PassengerRouteInteraction, RoutePrediction>>? _pool;
    private readonly object _lock = new();

    public RecommenderPredictionPool(MLContext mlContext) {
        _mlContext = mlContext;
    }

    public void Initialize(ITransformer model) {
        lock (_lock) {
            var policy = new PredictionEnginePoolPolicy<PassengerRouteInteraction, RoutePrediction>(
                _mlContext, model);
            _pool = new DefaultObjectPool<PredictionEngine<PassengerRouteInteraction, RoutePrediction>>(policy);
        }
    }

    public PredictionEngine<PassengerRouteInteraction, RoutePrediction> GetPredictionEngine() {
        if (_pool is null)
            throw new InvalidOperationException("Pool nije inicijalizovan.");
        return _pool.Get();
    }

    public void Return(PredictionEngine<PassengerRouteInteraction, RoutePrediction> engine) {
        _pool?.Return(engine);
    }
}