namespace MojPrijevoz.Model.Dtos.FareLocation;

public class FareLocationDto
{
    public int UserId { get; set; }
    public string Lat { get; set; } = null!;
    public string Lon { get; set; } = null!;
    public DateTime DateTime { get; set; }
    public bool IsAccurate { get; set; }
}