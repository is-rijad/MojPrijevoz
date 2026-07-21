namespace MojPrijevoz.Model.Responses.StopPoint;

public class StopPointResponse
{
    public int Id { get; set; }
    public short Order { get; set; }
    public int FareDataId { get; set; }
    public string Lat { get; set; } = null!;
    public string Long { get; set; } = null!;
    public string Name { get; set; } = null!;
}