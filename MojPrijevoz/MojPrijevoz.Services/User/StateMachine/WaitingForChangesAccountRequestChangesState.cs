using MojPrijevoz.Database;

namespace MojPrijevoz.Services.User.StateMachine;

public class WaitingForChangesAccountRequestChangesState : BaseAccountRequestChangesState
{
    public WaitingForChangesAccountRequestChangesState(IServiceProvider serviceProvider,
        MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.User SubmitForReview(Database.User entity)
    {
        entity.Status = AccountStatus.WaitingForReview;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(SubmitForReview) };
        return Task.FromResult(list);
    }
}
