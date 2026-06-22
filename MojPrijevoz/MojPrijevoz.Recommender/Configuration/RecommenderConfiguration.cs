using Microsoft.Extensions.DependencyInjection;
using Microsoft.ML;
using MojPrijevoz.Recommender.Pool;

namespace MojPrijevoz.Recommender.Configuration;

public static class RecommenderConfiguration
{
    public static void AddRecommenderService(this IServiceCollection serviceCollection)
    {
        serviceCollection.AddSingleton<MLContext>(_ => new MLContext(seed: 42));
        serviceCollection.AddSingleton<RecommenderPredictionPool>();
        serviceCollection.AddSingleton<RecommenderService>();
        serviceCollection.AddHostedService<RecommenderRetrainJob>();
    }
}