using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.FareOffer;

public class FareOfferActionRequest
{
    [MaxLength(500)] public string? Reason { get; set; }
}
