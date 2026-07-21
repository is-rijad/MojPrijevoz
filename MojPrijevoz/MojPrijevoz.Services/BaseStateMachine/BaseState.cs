using MojPrijevoz.Database;

namespace MojPrijevoz.Services.BaseStateMachine;

public abstract class BaseState<TEntity, TBaseState> where TEntity : class where TBaseState : class
{
    protected const string MethodNotAllowed = "Method not allowed!";
    protected readonly MojPrijevozDbContext _dbContext;
    protected readonly IServiceProvider ServiceProvider;

    protected BaseState(IServiceProvider serviceProvider,
        MojPrijevozDbContext dbContext)
    {
        ServiceProvider = serviceProvider;
        _dbContext = dbContext;
    }


    public virtual TEntity Create(TEntity entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public virtual TEntity Update(int id, TEntity entity)
    {
        throw new Exception(MethodNotAllowed);
    }

    public virtual void Delete(int id)
    {
        throw new Exception(MethodNotAllowed);
    }

    public abstract TBaseState GetState(short? state);
    public abstract Task<List<string>> AllowedActions(int id);
}