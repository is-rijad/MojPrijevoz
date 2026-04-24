using MojPrijevoz.Database;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class AcceptedFareOfferState : BaseFareOfferState
{
    public AcceptedFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }
    public override Database.FareOffer Pay(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Payed;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Pay) };
        return Task.FromResult(list);
    }
}