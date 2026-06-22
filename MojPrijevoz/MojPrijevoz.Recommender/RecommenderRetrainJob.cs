using Microsoft.Extensions.Hosting;

namespace MojPrijevoz.Recommender;

public class RecommenderRetrainJob : BackgroundService {
    private readonly RecommenderService _recommender;

    public RecommenderRetrainJob(
        RecommenderService recommender) {
        _recommender = recommender;
    }

    protected override async Task ExecuteAsync(CancellationToken ct) {
        await _recommender.LoadOrTrainAsync();

        while (!ct.IsCancellationRequested) {
            var now = DateTime.UtcNow;
            var next = now.Date.AddDays(1).AddHours(2);
            await Task.Delay(next - now, ct);

            await _recommender.TrainAsync();
        }
    }
}