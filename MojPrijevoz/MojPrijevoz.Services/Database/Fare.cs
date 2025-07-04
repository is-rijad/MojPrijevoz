namespace MojPrijevoz.Services.Database;

public class Fare
{
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public int DestinationCityId { get; set; }

    public int Length { get; set; }

    public int Duration { get; set; }

    public short Status { get; set; }

    public DateTime CreatedAt { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }

    public int? OfferId { get; set; }

    public virtual City DestinationCity { get; set; } = null!;

    public virtual User Driver { get; set; } = null!;

    public virtual FareOffer? Offer { get; set; }

    public virtual City OriginCity { get; set; } = null!;

    public virtual User Passenger { get; set; } = null!;

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<StopPoint> StopPoints { get; set; } = new List<StopPoint>();

    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}