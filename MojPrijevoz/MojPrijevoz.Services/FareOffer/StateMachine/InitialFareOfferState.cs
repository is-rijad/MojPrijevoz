using MojPrijevoz.Database;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class InitialFareOfferState : BaseFareOfferState
{
    public InitialFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.FareOffer Create(Database.FareOffer entity)
    {
        entity.Status = Database.FareOfferStatus.WaitingForResponse;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string>() { nameof(Create)};
        return Task.FromResult(list);
    }
}