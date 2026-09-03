using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Model.SearchObjects;

public class FareOfferSearchObject : BaseSearchObject
{
    public FareOfferStatus? Status { get; set; }
}