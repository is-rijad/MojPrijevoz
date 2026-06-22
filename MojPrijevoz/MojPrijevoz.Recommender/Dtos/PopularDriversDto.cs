using MojPrijevoz.Database;
using MojPrijevoz.Model.SearchObjects;

namespace MojPrijevoz.Recommender.Dtos;

public class PopularDriversDto
{
    public MojPrijevozDbContext Database { get; set; } = null!;
    public int? DriverId { get; set; }
    public RecommendedDriversSearchObject SearchObject { get; set; } = null!;
}