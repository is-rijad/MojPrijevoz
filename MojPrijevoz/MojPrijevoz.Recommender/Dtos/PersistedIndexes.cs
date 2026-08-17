namespace MojPrijevoz.Recommender.Dtos;

public class PersistedIndexes
{
    public Dictionary<string, uint> Routes { get; set; } = new();
    public Dictionary<string, uint> Passengers { get; set; } = new();
}