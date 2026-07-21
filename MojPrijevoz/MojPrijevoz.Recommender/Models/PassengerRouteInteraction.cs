using Microsoft.ML.Data;

namespace MojPrijevoz.Recommender.Models;

public class PassengerRouteInteraction
{
    [KeyType(1000000)] public uint PassengerId { get; set; }

    [KeyType(100000)] public uint RouteId { get; set; }

    public float Label { get; set; }
}