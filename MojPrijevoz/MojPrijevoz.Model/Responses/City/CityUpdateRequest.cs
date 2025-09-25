using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Responses.City;

public class CityUpdateRequest
{
    [MaxLength(32)] public string? Name { get; set; }

    [MaxLength(16)] public string? Long { get; set; }

    [MaxLength(16)] public string? Lat { get; set; }
}