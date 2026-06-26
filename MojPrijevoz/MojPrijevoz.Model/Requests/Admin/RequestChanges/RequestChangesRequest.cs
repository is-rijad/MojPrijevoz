namespace MojPrijevoz.Model.Requests.Admin.RequestChanges;

public class RequestChangesRequest
{
    public List<string> SelectedItems { get; set; } = null!;
    public Dictionary<string, string>? Notes { get; set; }
}