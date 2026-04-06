
using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.FareOffer;

public class FareOfferDriverPriceDto {
    [Required]
    public int DriverId { get; set; }
    [Required]

    public float Price { get; set; }
    [Required]

    public int UserVehicleId { get; set; }

}