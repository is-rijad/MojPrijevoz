using MojPrijevoz.Model.Responses.Admin.FareData;
using MojPrijevoz.Model.Responses.Admin.UserProfile;

namespace MojPrijevoz.Model.Responses.Admin.Fare;

public class AdminFareResponse
{
    public int Id { get; set; }
    public int FareDataId { get; set; }
    public int PassengerId { get; set; }
    public AdminFareDataResponse? FareData { get; set; }
    public AdminUserProfileResponse? Passenger { get; set; }
}