using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Admin.Rating;

public class AdminRatingUpdateRequest
{
    [Required] public bool IsVisible { get; set; }
}