using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MojPrijevoz.Model.Requests.DriversDiscount;

public class DriversDiscountUpsertRequest
{
    [Required]
    [Range(0, float.MaxValue, ErrorMessage = "Donja granica ne smije biti manja od 0.")]
    public float MinKm { get; set; }

    public float? MaxKm { get; set; }

    [Required]
    [Range(1, 100, ErrorMessage = "Popust mora biti između 1 i 100%.")]
    public float Discount { get; set; }

    [JsonIgnore] public int? ProfileId { get; set; }
}