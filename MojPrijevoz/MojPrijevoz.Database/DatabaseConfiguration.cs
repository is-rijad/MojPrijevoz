using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace MojPrijevoz.Database;

public static class DatabaseConfiguration
{
    public static void AddDatabaseServices(this IServiceCollection services, string connectionString)
    {
        services.AddDbContext<MojPrijevozDbContext>(options => { options.UseSqlServer(connectionString); });
    }
}