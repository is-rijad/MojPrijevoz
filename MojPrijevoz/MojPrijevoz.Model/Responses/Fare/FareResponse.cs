using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.FareData;
using MojPrijevoz.Model.Responses.User;

namespace MojPrijevoz.Model.Responses.Fare;

public class FareResponse {
    public int Id { get; set; }

    public short Status { get; set; }
    public int FareDataId { get; set; }
    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public DateTime CreatedAt { get; set; }
    public FareDataResponse? FareData { get; set; }
    public UserProfileResponse? Driver { get; set; }
    public UserProfileResponse? Passenger { get; set; }
}