using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MojPrijevoz.Model.Requests.UserVehicle;

public class UserVehicleUpsertRequest
{
    [Required] public int VehicleId { get; set; }

    [Required] public int ModelYear { get; set; }

    [MaxLength(9)] [Required] public string LicensePlate { get; set; } = null!;

    [Required] [Range(0, 100)] public float PricePerKm { get; set; }

    [JsonIgnore] public int? ProfileId { get; set; }
    [JsonIgnore] public bool IsFirstVehicle { get; set; } = false;
}