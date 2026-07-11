using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Admin.Stats;

public class FaresThisMonthResponse
{
    public FareStatus Status { get; set; }
    public int Count { get; set; }
}