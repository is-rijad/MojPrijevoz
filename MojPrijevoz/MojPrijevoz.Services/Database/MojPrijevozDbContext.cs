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
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Account__3214EC076FA573F4");

            entity.ToTable("Account");

            entity.HasIndex(e => e.Username, "UQ__Account__536C85E49E14A489").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Account__A9D10534BCB5A733").IsUnique();

            entity.Property(e => e.Email)
                .HasMaxLength(32)
                .IsUnicode(false);
            entity.Property(e => e.FirstName)
                .HasMaxLength(32)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(64)
                .IsUnicode(false);
            entity.Property(e => e.Password)
                .HasMaxLength(64)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.Username)
                .HasMaxLength(32)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Administrator>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Administ__3214EC07210970B8");

            entity.ToTable("Administrator");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__City__3214EC0764F84146");

            entity.ToTable("City");

            entity.Property(e => e.Lat)
                .HasMaxLength(16)
                .IsUnicode(false);
            entity.Property(e => e.Long)
                .HasMaxLength(16)
                .IsUnicode(false);
            entity.Property(e => e.Name)
                .HasMaxLength(32)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Fare>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Fare__3214EC07BCB6FFC7");

            entity.ToTable("Fare");

            entity.HasOne(d => d.DestinationCity).WithMany(p => p.FareDestinationCities)
                .HasForeignKey(d => d.DestinationCityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fare_Destination");

            entity.HasOne(d => d.Driver).WithMany(p => p.FareDrivers)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fare_Driver");

            entity.HasOne(d => d.Offer).WithMany(p => p.Fares)
                .HasForeignKey(d => d.OfferId)
                .HasConstraintName("FK_Fare_Offer");

            entity.HasOne(d => d.OriginCity).WithMany(p => p.FareOriginCities)
                .HasForeignKey(d => d.OriginCityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fare_Origin");

            entity.HasOne(d => d.Passenger).WithMany(p => p.FarePassengers)
                .HasForeignKey(d => d.PassengerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fare_Passenger");
        });

        modelBuilder.Entity<FareOffer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__FareOffe__3214EC076657435C");

            entity.ToTable("FareOffer");

            entity.HasOne(d => d.DestinationCity).WithMany(p => p.FareOfferDestinationCities)
                .HasForeignKey(d => d.DestinationCityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FareOffer_Destination");

            entity.HasOne(d => d.Driver).WithMany(p => p.FareOfferDrivers)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FareOffer_Driver");

            entity.HasOne(d => d.OriginCity).WithMany(p => p.FareOfferOriginCities)
                .HasForeignKey(d => d.OriginCityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FareOffer_Origin");

            entity.HasOne(d => d.Passenger).WithMany(p => p.FareOfferPassengers)
                .HasForeignKey(d => d.PassengerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FareOffer_Passenger");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.FareOffers)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FareOffer_Vehicle");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Notifica__3214EC0702ADD287");

            entity.ToTable("Notification");

            entity.Property(e => e.Message)
                .HasMaxLength(32)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Rating>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rating__3214EC07E2D5E6A8");

            entity.ToTable("Rating");

            entity.HasIndex(e => new { e.FareId, e.FromId, e.ToId }, "UQ_Rating").IsUnique();

            entity.Property(e => e.Comment)
                .HasMaxLength(256)
                .IsUnicode(false);

            entity.HasOne(d => d.Fare).WithMany(p => p.Ratings)
                .HasForeignKey(d => d.FareId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rating_Fare");

            entity.HasOne(d => d.From).WithMany(p => p.RatingFroms)
                .HasForeignKey(d => d.FromId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rating_From");

            entity.HasOne(d => d.To).WithMany(p => p.RatingTos)
                .HasForeignKey(d => d.ToId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rating_To");
        });

        modelBuilder.Entity<StopPoint>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__StopPoin__3214EC0778A7FE19");

            entity.ToTable("StopPoint");

            entity.HasIndex(e => new { e.FareId, e.Order }, "UQ_StopPoint").IsUnique();

            entity.Property(e => e.Lat)
                .HasMaxLength(16)
                .IsUnicode(false);
            entity.Property(e => e.Long)
                .HasMaxLength(16)
                .IsUnicode(false);

            entity.HasOne(d => d.Fare).WithMany(p => p.StopPoints)
                .HasForeignKey(d => d.FareId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StopPoint_Fare");
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Transact__3214EC071B4CE3F1");

            entity.ToTable("Transaction");

            entity.HasOne(d => d.Fare).WithMany(p => p.Transactions)
                .HasForeignKey(d => d.FareId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Transaction_Fare");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__User__3214EC07F3075592");

            entity.ToTable("User");

            entity.Property(e => e.Picture)
                .HasMaxLength(64)
                .IsUnicode(false);

            entity.HasOne(d => d.City).WithMany(p => p.Users)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_User_City");
        });

        modelBuilder.Entity<UserProfile>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserProf__3214EC079A04CFBD");

            entity.ToTable("UserProfile");

            entity.HasIndex(e => new { e.UserId, e.ProfileType }, "UQ_UserProfile").IsUnique();

            entity.HasOne(d => d.User).WithMany(p => p.UserProfiles)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserProfile_User");
        });

        modelBuilder.Entity<UserVehicle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserVehi__3214EC07F49804F0");

            entity.ToTable("UserVehicle");

            entity.Property(e => e.Picture)
                .HasMaxLength(64)
                .IsUnicode(false);

            entity.HasOne(d => d.Profile).WithMany(p => p.UserVehicles)
                .HasForeignKey(d => d.ProfileId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserVehicle_Profile");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.UserVehicles)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserVehicle_Vehicle");
        });

        modelBuilder.Entity<Vehicle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Vehicle__3214EC07351EED90");

            entity.ToTable("Vehicle");

            entity.Property(e => e.Manufacturer)
                .HasMaxLength(32)
                .IsUnicode(false);
            entity.Property(e => e.Model)
                .HasMaxLength(32)
                .IsUnicode(false);
        });
    }
}