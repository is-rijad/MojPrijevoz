using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public class Vehicle : IHasTimestamps {
    public int Id { get; set; }

    public string Manufacturer { get; set; } = null!;

    public string Model { get; set; } = null!;

    public int NumberOfSeats { get; set; }

    public virtual ICollection<UserVehicle>? UserVehicles { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}

public class VehicleEntityConfiguration : IEntityTypeConfiguration<Vehicle> {
    public void Configure(EntityTypeBuilder<Vehicle> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("Vehicle");

        entity.Property(e => e.Manufacturer)
            .HasMaxLength(32)
            .IsUnicode(false);
        entity.Property(e => e.Model)
            .HasMaxLength(32)
            .IsUnicode(false);
    }
}