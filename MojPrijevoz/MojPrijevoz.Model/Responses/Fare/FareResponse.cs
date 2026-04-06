using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Fare;

public class FareResponse {
    public int Id { get; set; }

    public FareStatus Status { get; set; }
    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public float Price { get; set; }
    public DateTime CreatedAt { get; set; }
}