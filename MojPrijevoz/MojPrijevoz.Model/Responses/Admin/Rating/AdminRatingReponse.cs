using MojPrijevoz.Model.Responses.Admin.Fare;

namespace MojPrijevoz.Model.Responses.Admin.Rating;

public class AdminRatingReponse : AdminAllRatingsResponse
{
    public string? Comment { get; set; }
    public int FareId { get; set; }
    public AdminFareResponse? Fare { get; set; }
}