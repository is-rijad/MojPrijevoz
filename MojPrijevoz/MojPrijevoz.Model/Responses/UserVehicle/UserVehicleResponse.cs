using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.Vehicle;
using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Responses.UserVehicle;

public class UserVehicleResponse
{
    public int Id { get; set; }

    public int VehicleId { get; set; }

    public int ModelYear { get; set; }

    public float FuelConsumption { get; set; }

    public float PricePerKm { get; set; }

    public string? Picture { get; set; }
    public UserVehicleStatus Status { get; set; }
    public VehicleResponse Vehicle { get; set; } = null!;
}