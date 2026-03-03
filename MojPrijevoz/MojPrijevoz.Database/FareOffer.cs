using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareOfferSide : short
{
    Driver = 0,
    Passenger = 1
}

public class FareOffer : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public FareOfferSide Side { get; set; }

    public float Price { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public int? LastOfferId { get; set; }

    public virtual Fare? Fare { get; set; }
    public virtual FareOffer? LastOffer { get; set; }

}

public class FareOfferEntityConfiguration : IEntityTypeConfiguration<FareOffer>
{
    public void Configure(EntityTypeBuilder<FareOffer> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("FareOffer");

        entity.HasOne<Fare>(it => it.Fare)
            .WithMany(it => it.FareOffers)
            .HasForeignKey(it => it.FareId);

        entity.HasOne<FareOffer>(it => it.LastOffer)
            .WithMany()
            .HasForeignKey(it => it.LastOfferId)
            .IsRequired(false);

    }
}