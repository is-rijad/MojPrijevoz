using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Recommender;

public class RecommendedDriverRouteResponse
{
    public int Id { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? Picture { get; set; }
    public AccountStatus Status { get; set; }
    public double AverageRating { get; set; }
    public string OriginCityName { get; set; } = null!;
    public string DestinationName { get; set; } = null!;
    public int RidesCount { get; set; }
}