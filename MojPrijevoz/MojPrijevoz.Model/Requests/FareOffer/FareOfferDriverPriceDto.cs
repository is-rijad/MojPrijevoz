
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MojPrijevoz.Model.Requests.FareOffer;

public class FareOfferDriverPriceDto {
    [Required]
    public int DriverId { get; set; }
    [Required]

    public float Price { get; set; }
    public float? AdditionalPrice { get; set; }
    [Required]

    public int UserVehicleId { get; set; }

}