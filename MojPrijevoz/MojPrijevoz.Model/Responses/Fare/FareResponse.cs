using MojPrijevoz.Model.Responses.FareData;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Model.Responses.UserVehicle;

namespace MojPrijevoz.Model.Responses.Fare;

public class FareResponse {
    public int Id { get; set; }

    public short Status { get; set; }
    public int FareDataId { get; set; }
    public int DriverId { get; set; }
    public DateTime? FareStartAfter { get; set; }
    public int UserVehicleId { get; set; }
    public int PassengerId { get; set; }

    public DateTime CreatedAt { get; set; }
    public FareDataResponse? FareData { get; set; }
    public UserProfileResponse? Driver { get; set; }
    public UserProfileResponse? Passenger { get; set; }
    public UserVehicleResponse? UserVehicle { get; set; }
    public List<FareOfferResponse>? FareOffers { get; set; }
}