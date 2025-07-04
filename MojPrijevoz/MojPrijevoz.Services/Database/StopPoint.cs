namespace MojPrijevoz.Services.Database;

public class StopPoint
{
    public int Id { get; set; }

    public int FareId { get; set; }

    public short Order { get; set; }

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;

    public virtual Fare Fare { get; set; } = null!;
}