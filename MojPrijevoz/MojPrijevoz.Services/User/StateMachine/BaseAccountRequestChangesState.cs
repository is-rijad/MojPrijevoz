using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.User.StateMachine;

public class BaseAccountRequestChangesState : BaseState<Database.User, BaseAccountRequestChangesState>
{
    public BaseAccountRequestChangesState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(
        serviceProvider, dbContext)
    {
    }

    public override BaseAccountRequestChangesState GetState(short? state)
    {
        switch (state)
        {
            case (short)AccountStatus.Active:
                return ServiceProvider.GetRequiredService<ActiveAccountRequestChangesState>();
            case (short)AccountStatus.WaitingForChanges:
                return ServiceProvider.GetRequiredService<WaitingForChangesAccountRequestChangesState>();
            case (short)AccountStatus.WaitingForReview:
                return ServiceProvider.GetRequiredService<WaitingForReviewAccountRequestChangesState>();
            default:
                throw new Exception(MethodNotAllowed);
        }
    }

    public virtual Database.User RequestChanges(Database.User entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.User SubmitForReview(Database.User entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public override async Task<List<string>> AllowedActions(int id)
    {
        var entity = await _dbContext.Users.FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Korisnik nije pronađen!");
        var state = GetState((short)entity.Status);
        return await state.AllowedActions(id);
    }
}
