using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Model.SearchObjects;

public class FareSearchObject : BaseSearchObject  {
    public int? FareId { get; set; }
    public ProfileType FareRole { get; set; }
}