using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Fare;

public class FareInsertRequest {
    public int OriginCityId { get; set; }
    public string? DestinationLat { get; set; }
    public string? DestinationLong { get; set; }
    [Range(1, int.MaxValue)] public int Length { get; set; }
    [Range(1, int.MaxValue)] public int Duration { get; set; }
    public int? DriverId { get; set; }
    public int PassengerId { get; set; }
    public float? Price { get; set; }
    public DateTime FareDateTime { get; set; }
}