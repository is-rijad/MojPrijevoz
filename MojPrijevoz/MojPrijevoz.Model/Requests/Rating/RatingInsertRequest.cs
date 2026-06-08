using System.ComponentModel.DataAnnotations;
using System.Security.Principal;
using System.Text.Json.Serialization;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Rating;

public class RatingInsertRequest
{
    [JsonIgnore]
    public int? FromId { get; set; }
    [JsonIgnore]

    public int? ToId { get; set; }
    [MaxLength(256)]
    public string? Comment { get; set; }
    [Range(1,5)]
    public short Grade { get; set; }
    [Required]
    public int FareId { get; set; }
    [Required]
    public ProfileType ProfileType { get; set; }
}