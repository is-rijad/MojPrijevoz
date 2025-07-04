namespace MojPrijevoz.Services.Database;

public class UserVehicle
{
    public int Id { get; set; }

    public int ProfileId { get; set; }

    public int VehicleId { get; set; }

    public int ModelYear { get; set; }

    public float FuelConsumption { get; set; }

    public float PricePerKm { get; set; }

    public string? Picture { get; set; }

    public short Status { get; set; }

    public virtual ICollection<FareOffer> FareOffers { get; set; } = new List<FareOffer>();

    public virtual UserProfile Profile { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}