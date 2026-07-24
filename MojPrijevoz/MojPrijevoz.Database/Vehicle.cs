using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class Vehicle
{
    public int Id { get; set; }

    public string Manufacturer { get; set; } = null!;

    public string Model { get; set; } = null!;

    public int NumberOfSeats { get; set; }

    public ICollection<UserVehicle>? UserVehicles { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public override string ToString()
    {
        return $"{Manufacturer} {Model}";
    }
}

public class VehicleEntityConfiguration : IEntityTypeConfiguration<Vehicle>
{
    public void Configure(EntityTypeBuilder<Vehicle> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("Vehicle");

        entity.Property(e => e.Manufacturer)
            .HasMaxLength(32)
            .IsUnicode(false)
            .UseCollation("Croatian_CI_AS");
        entity.Property(e => e.Model)
            .HasMaxLength(32)
            .IsUnicode(false)
            .UseCollation("Croatian_CI_AS");

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
        entity.Property(e => e.UpdatedAt).ValueGeneratedOnAddOrUpdate()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}