using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Services.OpenRoute;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class InNegotiationFareState : BaseFareState
{
    private readonly IOpenRouteService _openRouteService;

    public InNegotiationFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext, IOpenRouteService openRouteService) : base(serviceProvider, dbContext)
    {
        _openRouteService = openRouteService;
    }

    public override Database.Fare Reject(Database.Fare entity)
    {
        entity.Status = Database.FareStatus.Rejected;
        return entity;
    }
    public override async Task<Database.Fare> Accept(Database.Fare entity) {
        entity.Status = Database.FareStatus.Accepted;
        var fareData = await _dbContext.FareData.Where(fd => fd.Id == entity.FareDataId).FirstAsync();
        var cityFromId = await _dbContext.UserProfiles.Where(c => c.Id == entity.DriverId).Select(it => it.User!.CityId).FirstAsync();
        var route = await _openRouteService.GetDistance(new GetDistanceRequest() {CityFrom = cityFromId, CityTo = fareData.OriginCityId });
        entity.FareStartAfter = fareData.FareDateTime.AddMinutes((route.DurationInMinutes) * -1);

        var fares = await _dbContext.Fares.Include(it => it.FareOffers).Where(it => it.FareDataId == entity.FareDataId && it.Id != entity.Id).ToListAsync();
        foreach (var fare in fares)
        {
            fare.Status = FareStatus.Expired;
            foreach (var fareOffer in fare.FareOffers!)
            {
                fareOffer.Status = FareOfferStatus.Expired;
            }
        }


        return entity;
    }


    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Reject), nameof(Accept) };
        return Task.FromResult(list);
    }
}