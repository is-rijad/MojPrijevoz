using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MojPrijevoz.Model.Requests.StopPoint;

public class StopPointInsertRequest
{
    [NotMapped] public short Order { get; set; }
    [NotMapped] public int FareDataId { get; set; }
    [Required]
    public string Lat { get; set; } = null!;
    [Required]
    public string Long { get; set; } = null!;

    [Required]
    public string Name { get; set; } = null!;
}