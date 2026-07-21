namespace MojPrijevoz.Recommender.Dtos;

public class BuildResultDto : PopularDriversDto
{
    public BuildResultDto(PopularDriversDto dto)
    {
        Database = dto.Database;
        DriverId = dto.DriverId;
        SearchObject = dto.SearchObject;
    }

    public List<string> RouteKeys { get; set; } = null!;
}