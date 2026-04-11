using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.FareData;

public class FareDataInsertRequest {
    public int OriginCityId { get; set; }
    public string DestinationLat { get; set; } = null!;
    public string DestinationLong { get; set; } = null!;
    public string DestinationName { get; set; } = null!;
    [Range(1, int.MaxValue)] public int Length { get; set; }
    [Range(1, int.MaxValue)] public int Duration { get; set; }
    public DateTime FareDateTime { get; set; }
}