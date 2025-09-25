using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MojPrijevoz.Model.Requests.UserVehicle;

public class UserVehicleUpsertRequest : IValidatableObject
{
    public int VehicleId { get; set; }

    public int ModelYear { get; set; }

    [Range(0, 50)] public float FuelConsumption { get; set; }

    [Range(0, 10)] public float PricePerKm { get; set; }

    public string? Picture { get; set; }

    [JsonIgnore] public int? ProfileId { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (ModelYear < 1900)
            yield return new ValidationResult("Godina proizvodnje ne može biti manja od 1900.",
                new[] { nameof(ModelYear) });
        if (ModelYear > DateTime.Now.Year)
            yield return new ValidationResult($"Godina proizvodnje ne može biti veća od {DateTime.Now.Year}.",
                new[] { nameof(ModelYear) });
    }
}