namespace MojPrijevoz.Recommender.Dtos;

public class BuildResultDto : PopularDriversDto
{
    public Dictionary<string, float>? RouteScores { get; set; }
    public List<string> RouteKeys { get; set; } = null!;

    public BuildResultDto(PopularDriversDto dto)
    {
        Database = dto.Database;
        DriverId = dto.DriverId;
        SearchObject = dto.SearchObject;
    }

}