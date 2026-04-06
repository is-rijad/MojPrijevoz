using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareStatus : short {
    WaitingForNegotiation = 0,
    Pending = 1,
    Accepted = 2,
    Rejected = 3,
    Cancelled = 4,
    Completed = 5
}

public class Fare : IHasCreatedAtTimestamp {
    public int Id { get; set; }

    public FareStatus Status { get; set; } = FareStatus.WaitingForNegotiation;
    public int FareDataId { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }
    public virtual ICollection<Rating>? Ratings { get; set; }

    public virtual ICollection<Transaction>? Transactions { get; set; }
    public virtual FareData? FareData { get; set; }
    public virtual UserProfile? Driver { get; set; }

    public virtual UserProfile? Passenger { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class FareEntityConfiguration : IEntityTypeConfiguration<Fare> {
    public void Configure(EntityTypeBuilder<Fare> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("Fare");

        entity.Property(e => e.Status).IsRequired(true);

        entity.HasOne<FareData>(d => d.FareData)
            .WithOne(p => p.Fare)
            .HasForeignKey<Fare>(e => e.FareDataId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Driver)
            .WithMany(p => p.FareDrivers)
            .HasForeignKey(d => d.DriverId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Passenger)
            .WithMany(p => p.FarePassengers)
            .HasForeignKey(d => d.PassengerId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}