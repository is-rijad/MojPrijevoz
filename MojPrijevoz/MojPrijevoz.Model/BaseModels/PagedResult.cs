namespace MojPrijevoz.Model.BaseModels;

public class PagedResult<T>
{
    public List<T> Items { get; set; } = null!;
    public int Count { get; set; }
}