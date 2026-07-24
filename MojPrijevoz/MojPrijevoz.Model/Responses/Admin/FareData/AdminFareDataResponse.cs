using MojPrijevoz.Model.Responses.Admin.City;

namespace MojPrijevoz.Model.Responses.Admin.FareData;

public class AdminFareDataResponse
{
    public int Id { get; set; }
    public int OriginCityId { get; set; }
    public string DestinationName { get; set; } = null!;
    public AdminCityResponse? OriginCity { get; set; }
}