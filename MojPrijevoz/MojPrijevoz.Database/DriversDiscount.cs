using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class DriversDiscount
{
    public int Id { get; set; }
    public int ProfileId { get; set; }
    public float MinKm { get; set; }
    public float? MaxKm { get; set; }
    public float Discount { get; set; }
    public UserProfile? Profile { get; set; }
}

public class DriversDiscountEntityConfiguration : IEntityTypeConfiguration<DriversDiscount>
{
    public void Configure(EntityTypeBuilder<DriversDiscount> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("DriversDiscount");

        entity.Property(e => e.MinKm).IsRequired();
        entity.Property(e => e.Discount).IsRequired();
        entity.HasOne<UserProfile>(e => e.Profile)
            .WithMany(e => e.DriversDiscounts)
            .HasForeignKey(e => e.ProfileId);
    }
}