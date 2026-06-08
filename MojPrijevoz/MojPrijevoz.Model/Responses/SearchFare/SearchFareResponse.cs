using System.Text.Json.Serialization;
using MojPrijevoz.Model.Responses.UserVehicle;

namespace MojPrijevoz.Model.Responses.SearchFare;

public class SearchFareResponse {
    public int Id { get; set; }
    public int ProfileId { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? Picture { get; set; }
    public short Status { get; set; }
    public double AverageReview { get; set; }
    public int NumberOfReviews { get; set; }
    public ICollection<UserVehicleResponse>? Vehicles { get; set; }
    [JsonIgnore]
    public double Distance { get; set; }
}
