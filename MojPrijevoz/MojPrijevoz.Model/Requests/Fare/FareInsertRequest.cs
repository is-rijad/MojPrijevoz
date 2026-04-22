namespace MojPrijevoz.Model.Requests.Fare;

public class FareInsertRequest {
    public int? DriverId { get; set; }
    public int PassengerId { get; set; }
    public int? FareDataId { get; set; }
    public int? UserVehicleId { get; set; }
}