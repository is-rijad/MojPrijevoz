using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class StopPoint {
    public int Id { get; set; }

    public int FareId { get; set; }

    public short Order { get; set; }

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;

    public virtual Fare? Fare { get; set; }
}

public class StopPointEntityConfiguration : IEntityTypeConfiguration<StopPoint> {
    public void Configure(EntityTypeBuilder<StopPoint> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("StopPoint");

        entity.HasIndex(e => new { e.FareId, e.Order }).IsUnique();

        entity.Property(e => e.Lat)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Long)
            .HasMaxLength(16)
            .IsUnicode(false);

        entity.HasOne(d => d.Fare).WithMany(p => p.StopPoints)
            .HasForeignKey(d => d.FareId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}