using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.BaseStateMachine;

namespace MojPrijevoz.Services.UserVehicle.StateMachine;

public class BaseUserVehicleRequestChangesState : BaseState<Database.UserVehicle, BaseUserVehicleRequestChangesState>
{
    public BaseUserVehicleRequestChangesState(IServiceProvider serviceProvider, MojPrijevozDbContext dbContext) :
        base(serviceProvider, dbContext)
    {
    }

    public override BaseUserVehicleRequestChangesState GetState(short? state)
    {
        switch (state)
        {
            case (short)UserVehicleStatus.Active:
                return ServiceProvider.GetRequiredService<ActiveUserVehicleRequestChangesState>();
            case (short)UserVehicleStatus.WaitingForChanges:
                return ServiceProvider.GetRequiredService<WaitingForChangesUserVehicleRequestChangesState>();
            case (short)UserVehicleStatus.WaitingForReview:
                return ServiceProvider.GetRequiredService<WaitingForReviewUserVehicleRequestChangesState>();
            default:
                throw new Exception(MethodNotAllowed);
        }
    }

    public virtual Database.UserVehicle RequestChanges(Database.UserVehicle entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public virtual Database.UserVehicle SubmitForReview(Database.UserVehicle entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public override async Task<List<string>> AllowedActions(int id)
    {
        var entity = await _dbContext.UserVehicles.FindAsync(id);
        if (entity == null)
            throw new NotFoundException("Vozilo nije pronađeno!");
        var state = GetState((short)entity.Status);
        return await state.AllowedActions(id);
    }
}
