namespace MojPrijevoz.Model.Responses.Admin.Rating;

public class AdminAllRatingsResponse
{
    public int Id { get; set; }
    public int FromId { get; set; }
    public int ToId { get; set; }
    public Database.UserProfile? From { get; set; }
    public Database.UserProfile? To { get; set; }
    public short Grade { get; set; }
    public bool IsVisible { get; set; }
    public DateTime CreatedAt { get; set; }
}