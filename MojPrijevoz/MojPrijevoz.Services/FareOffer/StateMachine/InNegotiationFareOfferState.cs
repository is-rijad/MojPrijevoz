using MojPrijevoz.Database;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class InNegotiationFareOfferState : BaseFareOfferState {
    public InNegotiationFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext) {
    }
    public override Database.FareOffer Update(int id, Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.WaitingForResponse;
        return entity;
    }
    public override Database.FareOffer Reject(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Rejected;
        return entity;
    }
    public override Database.FareOffer Accept(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Accepted;
        return entity;
    }
    public override Database.FareOffer Expire(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Expired;
        return entity;
    }
    public override Database.FareOffer Cancel(Database.FareOffer entity) {
        entity.Status = Database.FareOfferStatus.Cancelled;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id) {
        var list = new List<string>() { nameof(Update), nameof(Accept), nameof(Reject), nameof(Cancel), nameof(Expire) };
        return Task.FromResult(list);
    }
}