using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Transaction;

public class TransactionInsertRequest {
    public int FareId { get; set; }

    public TransactionSide Side { get; set; }

    public float Amount { get; set; }
    public float FeeAmount { get; set; }
}