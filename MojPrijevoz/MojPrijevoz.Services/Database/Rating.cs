using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Services.Database;

public class Rating
{
    public int Id { get; set; }

    public int FromId { get; set; }

    public int ToId { get; set; }

    public string? Comment { get; set; }

    public short Grade { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public virtual Fare Fare { get; set; } = null!;

    public virtual User From { get; set; } = null!;

    public virtual User To { get; set; } = null!;
}

public class RatingEntityConfiguration : IEntityTypeConfiguration<Rating>
{
    public void Configure(EntityTypeBuilder<Rating> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__Rating__3214EC07E2D5E6A8");

        entity.ToTable("Rating");

        entity.HasIndex(e => new { e.FareId, e.FromId, e.ToId }, "UQ_Rating").IsUnique();

        entity.Property(e => e.Comment)
            .HasMaxLength(256)
            .IsUnicode(false);

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");

        entity.HasOne(d => d.Fare).WithMany(p => p.Ratings)
            .HasForeignKey(d => d.FareId)
            .OnDelete(DeleteBehavior.ClientSetNull)
            .HasConstraintName("FK_Rating_Fare");

        entity.HasOne(d => d.From).WithMany(p => p.RatingFroms)
            .HasForeignKey(d => d.FromId)
            .OnDelete(DeleteBehavior.ClientSetNull)
            .HasConstraintName("FK_Rating_From");

        entity.HasOne(d => d.To).WithMany(p => p.RatingTos)
            .HasForeignKey(d => d.ToId)
            .OnDelete(DeleteBehavior.ClientSetNull)
            .HasConstraintName("FK_Rating_To");
    }
}