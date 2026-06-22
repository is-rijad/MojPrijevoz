
namespace MojPrijevoz.Recommender.Dtos;

public class BuildResultDto : PopularDriversDto
{
    public List<string> RouteKeys { get; set; } = null!;

    public BuildResultDto(PopularDriversDto dto)
    {
        Database = dto.Database;
        DriverId = dto.DriverId;
        SearchObject = dto.SearchObject;
    }
}