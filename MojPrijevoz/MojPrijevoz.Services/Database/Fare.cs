using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Services.Database;

public enum FareStatus : short {
    Pending = 0,
    Accepted = 1,
    Rejected = 2,
    Cancelled = 3,
    Completed = 4
}

public class Fare
{
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public int DestinationCityId { get; set; }

    public int Length { get; set; }

    public int Duration { get; set; }

    public FareStatus Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }

    public int? OfferId { get; set; }

    public virtual City DestinationCity { get; set; } = null!;

    public virtual User Driver { get; set; } = null!;

    public virtual FareOffer? Offer { get; set; }

    public virtual City OriginCity { get; set; } = null!;

    public virtual User Passenger { get; set; } = null!;

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<StopPoint> StopPoints { get; set; } = new List<StopPoint>();

    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}

public class FareEntityConfiguration : IEntityTypeConfiguration<Fare>
{
    public void Configure(EntityTypeBuilder<Fare> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__Fare__3214EC07BCB6FFC7");

        entity.ToTable("Fare");

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");

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
    }
}