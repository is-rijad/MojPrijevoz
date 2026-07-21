using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Admin.City;

public class AdminCityUpsertRequest
{
    [Required] [MaxLength(36)] public required string Name { get; set; }

    [Required] [MaxLength(16)] public required string Lat { get; set; }

    [Required] [MaxLength(16)] public required string Long { get; set; }
}