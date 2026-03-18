using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Fare;

public class FareResponse
{
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public string DestinationLat { get; set; } = null!;

    public string DestinationLong { get; set; } = null!;

    public int Length { get; set; }

    public int Duration { get; set; }

    public FareStatus Status { get; set; }
    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }

    public DateTime FareDateTime { get; set; }
    public DateTime CreatedAt { get; set; }
}