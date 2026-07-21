using System.ComponentModel.DataAnnotations;
using MojPrijevoz.Model.Dtos.Nominatim;

namespace MojPrijevoz.Model.Requests.Fare;

public class HasActiveFareRequest
{
    [Required] public DateTime FareDateTime { get; set; }

    [Required] public int OriginCityId { get; set; }

    [Required] public NominatimCityDto DestinationCity { get; set; } = null!;
}