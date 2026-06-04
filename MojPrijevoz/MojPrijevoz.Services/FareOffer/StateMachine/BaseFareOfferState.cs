using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.FareOffer.StateMachine;

public class BaseFareOfferState : BaseState<Database.FareOffer, BaseFareOfferState> {

    public BaseFareOfferState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override BaseFareOfferState GetState(short? state)
    {
        switch (state)
        {
            case null:
                return ServiceProvider.GetRequiredService<InitialFareOfferState>();
            case (short)Database.FareOfferStatus.WaitingForResponse:
                return ServiceProvider.GetRequiredService<InNegotiationFareOfferState>();
            case (short)Database.FareOfferStatus.Accepted:
                return ServiceProvider.GetRequiredService<AcceptedFareOfferState>();
            default:
                throw new Exception(MethodNotAllowed);
        }
    }

    public virtual Database.FareOffer Reject(Database.FareOffer entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.FareOffer Accept(Database.FareOffer entity) {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.FareOffer Expire(Database.FareOffer entity) {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.FareOffer Pay(Database.FareOffer entity) {
        throw new Exception(MethodNotAllowed);
    }

    public override async Task<List<string>> AllowedActions(int id)
    {
     var entity = await _dbContext.FareOffers.FindAsync(id);
     if (entity == null)
         throw new NotFoundException("Ponuda nije pronađena!");
     var state = GetState((short)entity.Status);
     return await state.AllowedActions(id);
    }
}