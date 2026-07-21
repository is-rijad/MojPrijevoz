using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Admin.Vehicle;

public class AdminUpsertVehicleRequest
{
    [Required] public required string Manufacturer { get; set; }

    [Required] public required string Model { get; set; }
}