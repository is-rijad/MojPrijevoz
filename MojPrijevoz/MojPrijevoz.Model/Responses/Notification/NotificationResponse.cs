using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Notification;

public class NotificationResponse
{
    public int Id { get; set; }
    public string Message { get; set; } = null!;
    public string Type { get; set; } = null!;

    public bool IsRead { get; set; }
    public int? FareId { get; set; }
    public ProfileType? Side { get; set; }
    public int? RatingId { get; set; }
    public DateTime CreatedAt { get; set; }
}