using MojPrijevoz.Model.Dtos.Nominatim;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using MojPrijevoz.Model.Requests.StopPoint;

namespace MojPrijevoz.Model.Requests.FareOffer;

public class FareOfferInsertRequest : IValidatableObject {
    [Required] public int OriginCityId { get; set; }
    [Required] public NominatimCityDto DestinationCity { get; set; } = null!;
    [Required][Range(1, int.MaxValue)] public float Length { get; set; }
    [Required][Range(1, int.MaxValue)] public float Duration { get; set; }

    [NotMapped] public int PassengerId { get; set; }
    [NotMapped] public int FareDataId { get; set; }
    [NotMapped] public float Price { get; set; }
    [NotMapped] public int UserVehicleId { get; set; }

    [Required] public ICollection<FareOfferDriverPriceDto> DriversPrices { get; set; } = null!;
    [Required] public IReadOnlyList<StopPointInsertRequest> StopPoints { get; set; } = null!;

    [Required] public DateTime FareDateTime { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext) {
        if (FareDateTime < DateTime.Now) {
            yield return new ValidationResult("Vrijeme vožnje ne može biti u prošlosti!", [nameof(FareDateTime)]);
        }
    }
}