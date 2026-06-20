using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class PayedFareState : BaseFareState {
    public PayedFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext) {
    }
    public override Database.Fare Start(Database.Fare entity) {
        entity.Status = Database.FareStatus.InProgress;
        return entity;
    }
    public override Task<List<string>> AllowedActions(int id) {
        var list = new List<string>() { nameof(Start) };
        return Task.FromResult(list);
    }
}