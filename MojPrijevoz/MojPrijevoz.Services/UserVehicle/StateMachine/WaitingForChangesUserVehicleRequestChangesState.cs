using MojPrijevoz.Database;

namespace MojPrijevoz.Services.UserVehicle.StateMachine;

public class WaitingForChangesUserVehicleRequestChangesState : BaseUserVehicleRequestChangesState
{
    public WaitingForChangesUserVehicleRequestChangesState(IServiceProvider serviceProvider,
        MojPrijevozDbContext dbContext) : base(serviceProvider, dbContext)
    {
    }

    public override Database.UserVehicle SubmitForReview(Database.UserVehicle entity)
    {
        entity.Status = UserVehicleStatus.WaitingForReview;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(SubmitForReview) };
        return Task.FromResult(list);
    }
}
