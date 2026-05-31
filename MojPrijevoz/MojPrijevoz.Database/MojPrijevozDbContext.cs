using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public class MojPrijevozDbContext : DbContext {
    public MojPrijevozDbContext() {
    }

    public MojPrijevozDbContext(DbContextOptions<MojPrijevozDbContext> options)
        : base(options) {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Administrator> Administrators { get; set; }

    public virtual DbSet<City> Cities { get; set; }
    public virtual DbSet<DriversDiscount> DriversDiscounts { get; set; }

    public virtual DbSet<Fare> Fares { get; set; }

    public virtual DbSet<FareOffer> FareOffers { get; set; }
    public virtual DbSet<FareData> FareData { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Rating> Ratings { get; set; }

    public virtual DbSet<StopPoint> StopPoints { get; set; }

    public virtual DbSet<Transaction> Transactions { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserProfile> UserProfiles { get; set; }

    public virtual DbSet<UserVehicle> UserVehicles { get; set; }

    public virtual DbSet<Vehicle> Vehicles { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder) {
        base.OnModelCreating(modelBuilder);

        ApplyDefaultQueries(modelBuilder);

        modelBuilder.ApplyConfiguration(new AccountEntityConfiguration());
        modelBuilder.ApplyConfiguration(new AdministratorEntityConfiguration());
        modelBuilder.ApplyConfiguration(new CityEntityConfiguration());
        modelBuilder.ApplyConfiguration(new DriversDiscountEntityConfiguration());
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
        modelBuilder.ApplyConfiguration(new FareDataEntityConfiguration());
    }

    private void ApplyDefaultQueries(ModelBuilder modelBuilder)
    {
        //modelBuilder.Entity<UserVehicle>().HasQueryFilter(it => it.Status != UserVehicleStatus.Deleted);
    }

    private void UpdateTimestamps() {
        var entries = ChangeTracker.Entries().Where(e =>
            e is { Entity: IHasCreatedAtTimestamp, State: EntityState.Added } or { Entity: IHasTimestamps, State: EntityState.Modified });
        foreach (var entityEntry in entries)
            if (entityEntry.State == EntityState.Added)
                ((IHasCreatedAtTimestamp)entityEntry.Entity).CreatedAt = DateTime.UtcNow;
            else if (entityEntry.State == EntityState.Modified)
                ((IHasTimestamps)entityEntry.Entity).UpdatedAt = DateTime.UtcNow;
    }

    public override int SaveChanges() {
        UpdateTimestamps();
        return base.SaveChanges();
    }

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default) {
        UpdateTimestamps();
        return await base.SaveChangesAsync(cancellationToken);
    }
}