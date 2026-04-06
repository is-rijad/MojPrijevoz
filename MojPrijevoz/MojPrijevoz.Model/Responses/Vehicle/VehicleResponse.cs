namespace MojPrijevoz.Model.Responses.Vehicle;

public class VehicleResponse {
    public int Id { get; set; }

    public string Manufacturer { get; set; } = null!;

    public string Model { get; set; } = null!;

    public int NumberOfSeats { get; set; }
}