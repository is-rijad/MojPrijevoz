using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Responses.City;

public class CityInsertRequest
{
    [Required]
    [MaxLength(32)]
    public string Name { get; set; } = null!;
    [Required]
    [MaxLength(16)]
    public string Long { get; set; } = null!;
    [Required]
    [MaxLength(16)]
    public string Lat { get; set; } = null!;
}