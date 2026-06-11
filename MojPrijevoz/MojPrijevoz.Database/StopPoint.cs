using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class StopPoint {
    public int Id { get; set; }

    public int FareDataId { get; set; }

    public short Order { get; set; }

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;
    public string Name { get; set; } = null!;

    public FareData? FareData { get; set; }
}

public class StopPointEntityConfiguration : IEntityTypeConfiguration<StopPoint> {
    public void Configure(EntityTypeBuilder<StopPoint> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("StopPoint");

        entity.HasIndex(e => new { e.FareDataId, e.Order }).IsUnique();

        entity.Property(e => e.Lat)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Long)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Name)
            .HasMaxLength(int.MaxValue)
            .IsUnicode(true);

        entity.HasOne(d => d.FareData).WithMany(p => p.StopPoints)
            .HasForeignKey(d => d.FareDataId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}