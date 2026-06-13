using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class PayedFareState : BaseFareState
{
    public PayedFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.Fare Complete(Database.Fare entity) {
        entity.Status = Database.FareStatus.Completed;
        return entity;
    }
    public override Database.Fare Cancel(Database.Fare entity) {
        entity.Status = Database.FareStatus.Cancelled;
        return entity;
    }
    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Complete), nameof(Cancel) };
        return Task.FromResult(list);
    }
}