using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Services.OpenRoute;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class InNegotiationFareState : BaseFareState
{
    private readonly IOpenRouteService _openRouteService;

    public InNegotiationFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext,
        IOpenRouteService openRouteService) : base(serviceProvider, dbContext)
    {
        _openRouteService = openRouteService;
    }

    public override Database.Fare Reject(Database.Fare entity)
    {
        entity.Status = FareStatus.Rejected;
        return entity;
    }

    public override Database.Fare Cancel(Database.Fare entity)
    {
        entity.Status = FareStatus.Cancelled;
        return entity;
    }

    public override Database.Fare Expire(Database.Fare entity)
    {
        entity.Status = FareStatus.Expired;
        return entity;
    }

    public override async Task<Database.Fare> Accept(Database.Fare entity)
    {
        var fareData = await _dbContext.FareData.Where(fd => fd.Id == entity.FareDataId).FirstAsync();
        var cityFromId = await _dbContext.UserProfiles.Where(c => c.Id == entity.DriverId).Select(it => it.User!.CityId)
            .FirstAsync();
        var route = await _openRouteService.GetDistance(new GetDistanceRequest
            { CityFrom = cityFromId, CityTo = fareData.OriginCityId });
        entity.FareStartAfter = fareData.FareDateTime.AddMinutes((route.DurationInMinutes + 30) * -1);

        var fares = await _dbContext.Fares.Include(it => it.FareOffers)
            .Where(it => it.FareDataId == entity.FareDataId && it.Id != entity.Id).ToListAsync();
        foreach (var fare in fares)
        {
            fare.Status = FareStatus.Expired;
            foreach (var fareOffer in fare.FareOffers!) fareOffer.Status = FareOfferStatus.Expired;
        }

        entity.Status = FareStatus.Accepted;

        return entity;
    }


    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(Reject), nameof(Accept), nameof(Cancel), nameof(Expire) };
        return Task.FromResult(list);
    }
}