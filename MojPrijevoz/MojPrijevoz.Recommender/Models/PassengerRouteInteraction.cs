using Microsoft.ML.Data;

namespace MojPrijevoz.Recommender.Models;

public class PassengerRouteInteraction
{
    [KeyType(count: 50_000)]
    public uint PassengerId { get; set; }

    [KeyType(count: 20_000)]
    public uint RouteId { get; set; }

    public float Label { get; set; }
}