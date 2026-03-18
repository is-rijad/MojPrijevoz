using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public class Rating : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public int FromId { get; set; }

    public int ToId { get; set; }

    public string? Comment { get; set; }

    public short Grade { get; set; }

    public int FareId { get; set; }

    public virtual Fare? Fare { get; set; }

    public virtual UserProfile? From { get; set; }

    public virtual UserProfile? To { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class RatingEntityConfiguration : IEntityTypeConfiguration<Rating>
{
    public void Configure(EntityTypeBuilder<Rating> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("Rating");

        entity.HasIndex(e => new { e.FareId, e.FromId, e.ToId }).IsUnique();

        entity.Property(e => e.Comment)
            .HasMaxLength(256)
            .IsUnicode(false);

        entity.HasOne(d => d.Fare).WithMany(p => p.Ratings)
            .HasForeignKey(d => d.FareId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.From).WithMany(p => p.RatingFroms)
            .HasForeignKey(d => d.FromId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.HasOne(d => d.To).WithMany(p => p.RatingTos)
            .HasForeignKey(d => d.ToId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}