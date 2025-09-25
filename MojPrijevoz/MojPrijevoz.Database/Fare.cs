using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareStatus : short
{
    Pending = 0,
    Accepted = 1,
    Rejected = 2,
    Cancelled = 3,
    Completed = 4
}

public class Fare : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public int DestinationCityId { get; set; }

    public int Length { get; set; }

    public int Duration { get; set; }

    public FareStatus Status { get; set; } = FareStatus.Pending;

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }

    public int? OfferId { get; set; }

    public virtual City? DestinationCity { get; set; }

    public virtual User? Driver { get; set; }

    public virtual FareOffer? Offer { get; set; }

    public virtual City? OriginCity { get; set; }

    public virtual User? Passenger { get; set; }

    public virtual ICollection<Rating>? Ratings { get; set; }

    public virtual ICollection<StopPoint>? StopPoints { get; set; }

    public virtual ICollection<Transaction>? Transactions { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class FareEntityConfiguration : IEntityTypeConfiguration<Fare>
{
    public void Configure(EntityTypeBuilder<Fare> entity)
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
    }
}