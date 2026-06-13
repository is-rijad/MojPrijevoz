using MojPrijevoz.Database;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class PayedFareOfferState : BaseFareOfferState
{
    public PayedFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }
    public override Database.FareOffer Cancel(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Cancelled;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Cancel) };
        return Task.FromResult(list);
    }
}