using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum FareOfferStatus : short {
    Rejected = 0,
    Accepted = 1,
    WaitingForResponse = 2,
    Expired = 3,
    Payed = 4
}

public class FareOffer : IHasCreatedAtTimestamp {
    public int Id { get; set; }

    public ProfileType Side { get; set; }
    public FareOfferStatus Status { get; set; }

    public float Price { get; set; }
    public float? AdditionalPrice { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public int? LastOfferId { get; set; }

    public virtual Fare? Fare { get; set; }
    public virtual FareOffer? LastOffer { get; set; }
    public float TotalPrice => Price + (AdditionalPrice ?? 0);
}

public class FareOfferEntityConfiguration : IEntityTypeConfiguration<FareOffer> {
    public void Configure(EntityTypeBuilder<FareOffer> entity) {
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