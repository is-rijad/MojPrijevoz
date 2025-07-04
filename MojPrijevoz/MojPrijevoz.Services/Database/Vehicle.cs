namespace MojPrijevoz.Services.Database;

public class Vehicle
{
    public int Id { get; set; }

    public string Manufacturer { get; set; } = null!;

    public string Model { get; set; } = null!;

    public int NumberOfSeats { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<UserVehicle> UserVehicles { get; set; } = new List<UserVehicle>();
}