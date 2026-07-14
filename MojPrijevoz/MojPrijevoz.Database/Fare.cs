using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public enum FareStatus : short {
    Rejected = 0,
    Accepted = 1,
    InNegotiation = 2,
    Expired = 3,
    Payed = 4,
    Cancelled = 5,
    InProgress = 6,
    Completed = 7
}

public class Fare {
    public int Id { get; set; }

    public FareStatus Status { get; set; } = FareStatus.InNegotiation;
    public int FareDataId { get; set; }
    public int? UserVehicleId { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }
    public DateTime? FareStartAfter { get; set; }

    public ICollection<Transaction>? Transactions { get; set; }
    public FareData? FareData { get; set; }
    public UserProfile? Driver { get; set; }
    public ICollection<FareOffer>? FareOffers { get; set; }
    public UserVehicle? UserVehicle { get; set; }

    public UserProfile? Passenger { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class FareEntityConfiguration : IEntityTypeConfiguration<Fare> {
    public void Configure(EntityTypeBuilder<Fare> entity) {
        entity.HasKey(e => e.Id);
        entity.ToTable("Fare");

        entity.Property(e => e.Status).IsRequired();

        entity.HasOne<FareData>(d => d.FareData)
            .WithMany()
            .HasForeignKey(e => e.FareDataId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Driver)
            .WithMany()
            .HasForeignKey(d => d.DriverId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Passenger)
            .WithMany()
            .HasForeignKey(d => d.PassengerId)
            .OnDelete(DeleteBehavior.ClientSetNull);


        entity.HasOne<UserVehicle>(it => it.UserVehicle)
            .WithMany(it => it.Fares)
            .HasForeignKey(it => it.UserVehicleId);

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
        entity.Property(e => e.UpdatedAt).ValueGeneratedOnAddOrUpdate()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}