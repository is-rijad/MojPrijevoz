namespace MojPrijevoz.Model.Responses.Admin.Vehicle;

public class AdminAllVehiclesResponse
{
    public int Id { get; set; }
    public string Manufacturer { get; set; } = null!;

    public string Model { get; set; } = null!;
    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }
}