using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public enum UserVehicleStatus : short
{
    Deleted = 0,
    Active = 1,
    WaitingForChanges = 2
}

public class UserVehicle
{
    public int Id { get; set; }

    public int ProfileId { get; set; }

    public int VehicleId { get; set; }

    public int ModelYear { get; set; }

    public float FuelConsumption { get; set; }

    public float PricePerKm { get; set; }

    public string? Picture { get; set; }

    public UserVehicleStatus Status { get; set; }

    public virtual ICollection<FareOffer>? FareOffers { get; set; }

    public virtual UserProfile? Profile { get; set; }

    public virtual Vehicle? Vehicle { get; set; }
}

public class UserVehicleEntityConfiguration : IEntityTypeConfiguration<UserVehicle>
{
    public void Configure(EntityTypeBuilder<UserVehicle> entity)
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
    }
}