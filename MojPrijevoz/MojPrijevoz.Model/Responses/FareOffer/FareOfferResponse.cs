using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.Fare;

namespace MojPrijevoz.Model.Responses.FareOffer;

public class FareOfferResponse {
    public int Id { get; set; }

    public FareOfferSide Side { get; set; }

    public float Price { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public int? LastOfferId { get; set; }

    public virtual FareResponse? Fare { get; set; }
}