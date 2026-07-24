using System.ComponentModel.DataAnnotations;
using MojPrijevoz.Model.BaseModels.Admin;

namespace MojPrijevoz.Model.SearchObjects.Admin;

public class AdminTransactionSearchObject : OrderableSearchObject
{
    public int? UserId { get; set; }
    [Required]
    public int Month { get; set; }
    [Required] public bool IsPosted { get; set; }
}