using MojPrijevoz.Database;

namespace MojPrijevoz.Services.UserVehicle.StateMachine;

public class ActiveUserVehicleRequestChangesState : BaseUserVehicleRequestChangesState
{
    public ActiveUserVehicleRequestChangesState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) :
        base(serviceProvider, dbContext)
    {
    }

    public override Database.UserVehicle RequestChanges(Database.UserVehicle entity)
    {
        entity.Status = UserVehicleStatus.WaitingForChanges;
        return entity;
    }

    public override Task<List<string>> AllowedActions(int id)
    {
        var list = new List<string> { nameof(RequestChanges) };
        return Task.FromResult(list);
    }
}
