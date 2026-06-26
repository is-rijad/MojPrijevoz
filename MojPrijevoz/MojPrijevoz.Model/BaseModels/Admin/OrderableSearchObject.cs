namespace MojPrijevoz.Model.BaseModels.Admin;

public class OrderableSearchObject : BaseSearchObject
{
    public string? OrderBy { get; set; }
    public string? OrderDirection { get; set; }
}