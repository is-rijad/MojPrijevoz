namespace MojPrijevoz.Model.Responses.Admin.Stats;

public class AdminUsersByCityResponse
{
    public string CityName { get; set; } = null!;
    public string Lat { get; set; } = null!;
    public string Long { get; set; } = null!;
    public int UsersCount { get; set; }
}