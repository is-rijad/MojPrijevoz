using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MojPrijevoz.Model.Requests.UserVehicle;

public class UserVehicleUpsertRequest : IValidatableObject {
    [Required] public int VehicleId { get; set; }

    [Required] public int ModelYear { get; set; }

    [MaxLength(9)] [Required] public string LicensePlate { get; set; } = null!;

    [Required] [Range(0, 100)] public float PricePerKm { get; set; }

    [JsonIgnore] public int? ProfileId { get; set; }
    [JsonIgnore] public bool IsFirstVehicle { get; set; } = false;

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext) {
        if (ModelYear < 1900)
            yield return new ValidationResult("Godina proizvodnje ne može biti manja od 1900.",
                new[] { nameof(ModelYear) });
        if (ModelYear > DateTime.Now.Year)
            yield return new ValidationResult($"Godina proizvodnje ne može biti veća od {DateTime.Now.Year}.",
                new[] { nameof(ModelYear) });
    }
}