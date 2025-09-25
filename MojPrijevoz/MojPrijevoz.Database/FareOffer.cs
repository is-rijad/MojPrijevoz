using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareOfferSide : short
{
    Driver = 0,
    Passenger = 1
}

public class FareOffer : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public FareOfferSide Side { get; set; }

    public float Budget { get; set; }

    public int VehicleId { get; set; }

    public int OriginCityId { get; set; }

    public int DestinationCityId { get; set; }

    public virtual City? DestinationCity { get; set; }

    public virtual User? Driver { get; set; }

    public virtual ICollection<Fare>? Fares { get; set; }

    public virtual City? OriginCity { get; set; }

    public virtual User? Passenger { get; set; }

    public virtual UserVehicle? Vehicle { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class FareOfferEntityConfiguration : IEntityTypeConfiguration<FareOffer>
{
    public void Configure(EntityTypeBuilder<FareOffer> entity)
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
    }
}