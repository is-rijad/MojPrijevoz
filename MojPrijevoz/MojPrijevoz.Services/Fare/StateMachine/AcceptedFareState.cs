using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class AcceptedFareState : BaseFareState
{
    public AcceptedFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider,
        dbContext)
    {
    }

    public override Database.Fare Cancel(Database.Fare entity)
    {
        entity.Status = FareStatus.Cancelled;
        return entity;
    }

    public override Database.Fare Pay(Database.Fare entity)
    {
        entity.Status = FareStatus.Payed;
        return entity;
    }

    public override Database.Fare Expire(Database.Fare entity)
    {
        entity.Status = FareStatus.Expired;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(Cancel), nameof(Pay), nameof(Expire) };
        return Task.FromResult(list);
    }
}