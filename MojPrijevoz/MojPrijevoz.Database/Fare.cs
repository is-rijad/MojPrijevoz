using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareStatus : short
{
    WaitingForNegotiation = 0,
    Pending = 1,
    Accepted = 2,
    Rejected = 3,
    Cancelled = 4,
    Completed = 5
}

public class Fare : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public string DestinationLat { get; set; } = null!;

    public string DestinationLong { get; set; } = null!;

    public int Length { get; set; }

    public int Duration { get; set; }

    public FareStatus Status { get; set; } = FareStatus.WaitingForNegotiation;

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }

    public DateTime FareDateTime { get; set; }

    public virtual UserProfile? Driver { get; set; }

    public virtual City? OriginCity { get; set; }

    public virtual UserProfile? Passenger { get; set; }

    public virtual ICollection<Rating>? Ratings { get; set; }

    public virtual ICollection<StopPoint>? StopPoints { get; set; }

    public virtual ICollection<Transaction>? Transactions { get; set; }
    public virtual ICollection<FareOffer>? FareOffers { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class FareEntityConfiguration : IEntityTypeConfiguration<Fare>
{
    public void Configure(EntityTypeBuilder<Fare> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("Fare");

        entity.Property(e => e.DestinationLat)
            .HasMaxLength(16)
            .IsUnicode(false);

        entity.Property(e => e.DestinationLong)
            .HasMaxLength(16)
            .IsUnicode(false);

        entity.HasOne(d => d.Driver).WithMany(p => p.FareDrivers)
            .HasForeignKey(d => d.DriverId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.OriginCity).WithMany(p => p.FareOriginCities)
            .HasForeignKey(d => d.OriginCityId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Passenger).WithMany(p => p.FarePassengers)
            .HasForeignKey(d => d.PassengerId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}