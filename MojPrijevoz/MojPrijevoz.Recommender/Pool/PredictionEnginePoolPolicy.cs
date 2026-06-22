using Microsoft.Extensions.ObjectPool;
using Microsoft.ML;

namespace MojPrijevoz.Recommender.Pool;

public class PredictionEnginePoolPolicy<TInput, TOutput>
    : IPooledObjectPolicy<PredictionEngine<TInput, TOutput>>
    where TInput : class
    where TOutput : class, new() {
    private readonly MLContext _mlContext;
    private readonly ITransformer _model;

    public PredictionEnginePoolPolicy(MLContext mlContext, ITransformer model) {
        _mlContext = mlContext;
        _model = model;
    }

    public PredictionEngine<TInput, TOutput> Create() =>
        _mlContext.Model.CreatePredictionEngine<TInput, TOutput>(_model);

    public bool Return(PredictionEngine<TInput, TOutput> obj) => true;
}