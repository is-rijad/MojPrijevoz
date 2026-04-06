namespace MojPrijevoz.Model.Responses.FareData;

public class FareDataResponse {
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public string DestinationLat { get; set; } = null!;

    public string DestinationLong { get; set; } = null!;

    public int Length { get; set; }

    public int Duration { get; set; }

    public DateTime FareDateTime { get; set; }
    public DateTime CreatedAt { get; set; }
}