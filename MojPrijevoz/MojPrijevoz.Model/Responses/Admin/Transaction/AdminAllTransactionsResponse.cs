using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.Admin.Fare;

namespace MojPrijevoz.Model.Responses.Admin.Transaction;

public class AdminAllTransactionsResponse
{
    public int Id { get; set; }

    public int FareId { get; set; }

    public TransactionSide Side { get; set; }

    public float Amount { get; set; }
    public float FeeAmount { get; set; }

    public DateTime? PostedAt { get; set; }

    public AdminFareResponse? Fare { get; set; }

    public DateTime CreatedAt { get; set; }
}