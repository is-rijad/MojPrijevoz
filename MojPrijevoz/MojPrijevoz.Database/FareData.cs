using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public class FareData : IHasCreatedAtTimestamp
{
    public int Id { get; set; }
    public int OriginCityId { get; set; }

    public string DestinationLat { get; set; } = null!;

    public string DestinationLong { get; set; } = null!;
    public string DestinationName { get; set; } = null!;

    public int Length { get; set; }

    public int Duration { get; set; }
    public DateTime FareDateTime { get; set; }
    public City? OriginCity { get; set; }
    public Fare? Fare { get; set; }
    public ICollection<StopPoint>? StopPoints { get; set; }

    public DateTime CreatedAt { get; set; }

    //Has to be there because of seeder
    [NotMapped]
    public string _originLat { get; set; } = null!;
    [NotMapped]
    public string _originLong { get; set; } = null!;
}

public class FareDataEntityConfiguration : IEntityTypeConfiguration<FareData> {
    public void Configure(EntityTypeBuilder<FareData> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("FareData");

        entity.Property(e => e.DestinationLat)
            .HasMaxLength(16)
            .IsUnicode(false);

        entity.Property(e => e.DestinationLong)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.DestinationName)
            .HasMaxLength(int.MaxValue)
            .IsUnicode(true);

        entity.Property(e => e.Duration)
            .IsRequired(true);
        entity.Property(e => e.Length)
            .IsRequired(true);

        entity.Property(e => e.FareDateTime)
            .IsRequired(true);

        entity.HasOne(d => d.OriginCity)
            .WithMany(p => p.FareDataOriginCities)
            .HasForeignKey(d => d.OriginCityId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}