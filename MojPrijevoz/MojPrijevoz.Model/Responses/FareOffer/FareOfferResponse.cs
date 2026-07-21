namespace MojPrijevoz.Model.Responses.FareOffer;

public class FareOfferResponse
{
    public int Id { get; set; }

    public short Side { get; set; }
    public short Status { get; set; }

    public float Price { get; set; }
    public float? AdditionalPrice { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public int? LastOfferId { get; set; }
}