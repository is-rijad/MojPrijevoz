using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Model.SearchObjects;

public class FareSearchObject : BaseSearchObject  {
    public ProfileType FareRole { get; set; }
}