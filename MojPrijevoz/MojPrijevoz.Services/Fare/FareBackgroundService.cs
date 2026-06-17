using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MojPrijevoz.Services.FareOffer;

namespace MojPrijevoz.Services.Fare;

public class FareBackgroundService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;

    public FareBackgroundService(IServiceScopeFactory scopeFactory)
    {
        _scopeFactory = scopeFactory;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(TimeSpan.FromHours(1));

        while (await timer.WaitForNextTickAsync(stoppingToken)) {
            await DoWorkAsync();
        }
       
    }

    private async Task DoWorkAsync()
    {
        await using var scope = _scopeFactory.CreateAsyncScope();
        var fareService = scope.ServiceProvider.GetRequiredService<IFareService>();
        var fareOfferService = scope.ServiceProvider.GetRequiredService<IFareOfferService>();
        await fareService.MarkAsCompleted();
        await fareOfferService.MarkAsExpired();
    }
}