using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class AcceptedFareState : BaseFareState
{
    public AcceptedFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.Fare Cancel(Database.Fare entity)
    {
        entity.Status = Database.FareStatus.Cancelled;
        return entity;
    }
    public override Database.Fare Pay(Database.Fare entity) {
        entity.Status = Database.FareStatus.Payed;
        return entity;
    }
    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Cancel), nameof(Pay) };
        return Task.FromResult(list);
    }
}