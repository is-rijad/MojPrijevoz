using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Responses.City;

public class CityInsertRequest
{
    [Required] [MaxLength(32)] public required string Name { get; set; }

    [Required] [MaxLength(16)] public required string Long { get; set; }

    [Required] [MaxLength(16)] public required string Lat { get; set; }
}