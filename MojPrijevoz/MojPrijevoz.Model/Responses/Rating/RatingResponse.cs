using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Rating;

public class RatingResponse
{
    public int Id { get; set; }

    public int FromId { get; set; }


    public string? Comment { get; set; }

    public short Grade { get; set; }

    public int FareId { get; set; }

    public UserProfile? From { get; set; }


    public DateTime CreatedAt { get; set; }
}