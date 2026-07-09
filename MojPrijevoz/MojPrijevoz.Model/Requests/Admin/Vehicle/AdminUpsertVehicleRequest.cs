namespace MojPrijevoz.Model.Requests.Admin.Vehicle;

public class AdminUpsertVehicleRequest
{
    public required string Manufacturer { get; set; }

    public required string Model { get; set; }
}