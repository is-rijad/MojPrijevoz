using MojPrijevoz.Model.Responses.City;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.Responses.StopPoint;

namespace MojPrijevoz.Model.Responses.FareData;

public class FareDataResponse {
    public int Id { get; set; }

    public int OriginCityId { get; set; }

    public string DestinationLat { get; set; } = null!;

    public string DestinationLong { get; set; } = null!;
    public string DestinationName { get; set; } = null!;

    public int Length { get; set; }

    public int Duration { get; set; }

    public DateTime FareDateTime { get; set; }
    public DateTime CreatedAt { get; set; }
    public ICollection<StopPointResponse>? StopPoints { get; set; }
    public CityResponse? OriginCity { get; set; }
}