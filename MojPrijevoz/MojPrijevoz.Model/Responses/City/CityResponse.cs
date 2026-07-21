namespace MojPrijevoz.Model.Responses.City;

public class CityResponse {
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string Long { get; set; } = null!;
    public string Lat { get; set; } = null!;
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}