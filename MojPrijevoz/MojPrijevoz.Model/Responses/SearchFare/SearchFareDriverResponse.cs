namespace MojPrijevoz.Model.Responses.SearchFare;

public class SearchFareDriverResponse
{
    public int Id { get; set; }
    public int VehicleId { get; set; }
    public int UserVehicleId { get; set; }
    public double Price { get; set; }
    public double? AdditionalPrice { get; set; }
}