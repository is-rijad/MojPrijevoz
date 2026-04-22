using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class InitialFareState : BaseFareState
{
    public InitialFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.Fare Create(Database.Fare entity)
    {
        entity.Status = Database.FareStatus.InNegotiation;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Create) };
        return Task.FromResult(list);
    }
}