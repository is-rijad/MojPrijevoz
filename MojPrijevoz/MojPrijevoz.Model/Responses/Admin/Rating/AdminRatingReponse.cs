namespace MojPrijevoz.Model.Responses.Admin.Rating;

public class AdminRatingReponse : AdminAllRatingsResponse
{
    public string? Comment { get; set; }
    public int FareId { get; set; }
    public Database.Fare? Fare { get; set; }
}