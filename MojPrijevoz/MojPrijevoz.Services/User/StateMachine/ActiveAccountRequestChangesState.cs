using MojPrijevoz.Database;

namespace MojPrijevoz.Services.User.StateMachine;

public class ActiveAccountRequestChangesState : BaseAccountRequestChangesState
{
    public ActiveAccountRequestChangesState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) : base(
        serviceProvider, dbContext)
    {
    }

    public override Database.User RequestChanges(Database.User entity)
    {
        entity.Status = AccountStatus.WaitingForChanges;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(RequestChanges) };
        return Task.FromResult(list);
    }
}
