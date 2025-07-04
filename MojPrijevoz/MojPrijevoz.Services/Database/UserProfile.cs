namespace MojPrijevoz.Services.Database;

public class UserProfile
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public short ProfileType { get; set; }

    public int NumberOfFares { get; set; }

    public virtual User User { get; set; } = null!;

    public virtual ICollection<UserVehicle> UserVehicles { get; set; } = new List<UserVehicle>();
}