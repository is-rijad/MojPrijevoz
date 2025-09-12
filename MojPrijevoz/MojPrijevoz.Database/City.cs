using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class City
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;

    public DateTime UpdatedAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Fare>? FareDestinationCities { get; set; }

    public virtual ICollection<FareOffer>? FareOfferDestinationCities { get; set; }

    public virtual ICollection<FareOffer>? FareOfferOriginCities { get; set; }

    public virtual ICollection<Fare>? FareOriginCities { get; set; }

    public virtual ICollection<User>? Users { get; set; }
}

public class CityEntityConfiguration : IEntityTypeConfiguration<City>
{
    public void Configure(EntityTypeBuilder<City> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__City__3214EC0764F84146");

        entity.ToTable("City");

        entity.Property(e => e.Lat)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Long)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Name)
            .HasMaxLength(32)
            .IsUnicode(false);

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");

        entity.Property(e => e.UpdatedAt).ValueGeneratedOnAddOrUpdate()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}