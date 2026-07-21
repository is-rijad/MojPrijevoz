using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Transaction;

public class TransactionResponse
{
    public int Id { get; set; }

    public int FareId { get; set; }

    public TransactionSide Side { get; set; }

    public float Amount { get; set; }

    public DateTime? PostedAt { get; set; }

    public DateTime CreatedAt { get; set; }
}