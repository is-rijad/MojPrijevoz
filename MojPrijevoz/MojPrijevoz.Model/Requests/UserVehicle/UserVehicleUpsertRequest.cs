using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.UserVehicle;

public class UserVehicleUpsertRequest : IValidatableObject {
    public int? Id { get; set; }

    public int? VehicleId { get; set; }

    public int? ModelYear { get; set; }

    [Range(0, 50)]
    public float? FuelConsumption { get; set; }

    [Range(0, 10)]
    public float? PricePerKm { get; set; }

    public string? Picture { get; set; }

    [JsonIgnore]
    public int? ProfileId { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (!Id.HasValue)
        {

        }

        if (!VehicleId.HasValue)
        {

        }
        if (ModelYear.HasValue)
        {
            if (ModelYear < 1900)
                yield return new ValidationResult("Godina proizvodnje ne može biti manja od 1900.", new[] { nameof(ModelYear) });
            if (ModelYear > DateTime.Now.Year)
                yield return new ValidationResult($"Godina proizvodnje ne može biti veća od {DateTime.Now.Year}.", new[] { nameof(ModelYear) });
        }
    }
}