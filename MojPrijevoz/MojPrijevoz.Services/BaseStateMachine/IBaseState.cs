namespace MojPrijevoz.Services.BaseStateMachine;

public interface IBaseState
{
    public Task<List<string>> AllowedActions(int id);
}