using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Model.SearchObjects;

public class SearchFareSearchObject : BaseSearchObject {
    public int OriginCityId { get; set; }
    public DateTime FareDateTime { get; set; }
    public double? Budget { get; set; }
    public double Distance { get; set; }
    public double Duration { get; set; }
    public int? DriverId { get; set; }
}