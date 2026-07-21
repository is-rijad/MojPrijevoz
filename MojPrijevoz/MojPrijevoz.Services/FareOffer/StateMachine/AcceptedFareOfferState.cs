using MojPrijevoz.Database;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class AcceptedFareOfferState : BaseFareOfferState
{
    public AcceptedFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(
        serviceProvider, dbContext)
    {
    }

    public override Database.FareOffer Pay(Database.FareOffer entity)
    {
        entity.Status = FareOfferStatus.Payed;
        return entity;
    }

    public override Database.FareOffer Cancel(Database.FareOffer entity)
    {
        entity.Status = FareOfferStatus.Cancelled;
        return entity;
    }

    public override Database.FareOffer Expire(Database.FareOffer entity)
    {
        entity.Status = FareOfferStatus.Expired;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(Pay), nameof(Cancel), nameof(Expire) };
        return Task.FromResult(list);
    }
}