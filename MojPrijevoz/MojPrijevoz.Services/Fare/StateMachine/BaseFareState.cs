using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.Fare.StateMachine;

public class BaseFareState : BaseState<Database.Fare, BaseFareState> {
    public BaseFareState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override BaseFareState GetState(short? state)
    {
        switch (state)
        {
            case null:
                return ServiceProvider.GetRequiredService<InitialFareState>();
                break;
            case (short)Database.FareStatus.InNegotiation:
                return ServiceProvider.GetRequiredService<InNegotiationFareState>();
                break;
            case (short)Database.FareStatus.Accepted:
                return ServiceProvider.GetRequiredService<AcceptedFareState>();
                break;
            case (short)Database.FareStatus.Payed:
                return ServiceProvider.GetRequiredService<PayedFareState>();
                break;
            default:
                throw new Exception(MethodNotAllowed);
        }
    }
    public virtual Task<Database.Fare> Accept(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }
    public virtual Database.Fare Reject(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }
    public virtual Database.Fare Cancel(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }
    public virtual Database.Fare Complete(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.Fare Start(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }
    public virtual Database.Fare Pay(Database.Fare entity) {
        throw new Exception(MethodNotAllowed);
    }

    public override async Task<List<string>> AllowedActions(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Vožnja nije pronađena!");
        var state = GetState((short)entity.Status);
        return await state.AllowedActions(id);
    }
}