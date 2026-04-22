using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public enum UserVehicleStatus : short {
    Deleted = 0,
    Active = 1,
    WaitingForChanges = 2,
    WaitingForReview = 3
}

public class UserVehicle {
    public int Id { get; set; }

    public int ProfileId { get; set; }

    public int VehicleId { get; set; }

    public int ModelYear { get; set; }

    public string LicensePlate { get; set; } = null!;

    public float PricePerKm { get; set; }

    public string? Picture { get; set; }

    public UserVehicleStatus Status { get; set; } = UserVehicleStatus.WaitingForReview;

    public virtual ICollection<Fare>? Fares { get; set; }

    public virtual UserProfile? Profile { get; set; }

    public virtual Vehicle? Vehicle { get; set; }
}

public class UserVehicleEntityConfiguration : IEntityTypeConfiguration<UserVehicle> {
    public void Configure(EntityTypeBuilder<UserVehicle> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("UserVehicle");

        entity.Property(e => e.Picture)
            .HasMaxLength(64)
            .IsUnicode(false);

        entity.Property(e => e.LicensePlate)
            .HasMaxLength(9)
            .IsUnicode(false);

        entity.HasIndex(e => new { e.ProfileId, e.VehicleId, e.ModelYear }).IsUnique();

        entity.HasOne(d => d.Profile).WithMany(p => p.UserVehicles)
            .HasForeignKey(d => d.ProfileId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.Vehicle).WithMany(p => p.UserVehicles)
            .HasForeignKey(d => d.VehicleId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}