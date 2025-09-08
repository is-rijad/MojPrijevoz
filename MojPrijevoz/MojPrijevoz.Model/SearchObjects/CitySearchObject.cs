using MojPrijevoz.Model.BaseModels;

namespace MojPrijevoz.Model.SearchObjects;

public class CitySearchObject : BaseSearchObject {
    public string? Contains { get; set; }
}