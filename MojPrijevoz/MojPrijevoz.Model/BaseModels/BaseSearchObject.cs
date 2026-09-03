namespace MojPrijevoz.Model.BaseModels;

public abstract class BaseSearchObject
{
    private int _pageSize = 10;

    public int Page { get; set; } = 1;

    public int PageSize
    {
        get => _pageSize;
        set => _pageSize = Math.Clamp(value <= 0 ? 10 : value, 1, 100);
    }
}