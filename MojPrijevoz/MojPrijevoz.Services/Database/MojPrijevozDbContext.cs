using Microsoft.EntityFrameworkCore;

namespace MojPrijevoz.Services.Database;

public class MojPrijevozDbContext : DbContext
{
    public MojPrijevozDbContext()
    {
    }

    public MojPrijevozDbContext(DbContextOptions<MojPrijevozDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Administrator> Administrators { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Fare> Fares { get; set; }

    public virtual DbSet<FareOffer> FareOffers { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Rating> Ratings { get; set; }

    public virtual DbSet<StopPoint> StopPoints { get; set; }

    public virtual DbSet<Transaction> Transactions { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserProfile> UserProfiles { get; set; }

    public virtual DbSet<UserVehicle> UserVehicles { get; set; }

    public virtual DbSet<Vehicle> Vehicles { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfiguration(new AccountEntityConfiguration());
        modelBuilder.ApplyConfiguration(new AdministratorEntityConfiguration());
        modelBuilder.ApplyConfiguration(new CityEntityConfiguration());
        modelBuilder.ApplyConfiguration(new FareEntityConfiguration());
        modelBuilder.ApplyConfiguration(new FareOfferEntityConfiguration());
        modelBuilder.ApplyConfiguration(new NotificationEntityConfiguration());
        modelBuilder.ApplyConfiguration(new RatingEntityConfiguration());
        modelBuilder.ApplyConfiguration(new StopPointEntityConfiguration());
        modelBuilder.ApplyConfiguration(new TransactionEntityConfiguration());
        modelBuilder.ApplyConfiguration(new UserEntityConfiguration());
        modelBuilder.ApplyConfiguration(new UserProfileEntityConfiguration());
        modelBuilder.ApplyConfiguration(new UserVehicleEntityConfiguration());
        modelBuilder.ApplyConfiguration(new VehicleEntityConfiguration());
    }
}