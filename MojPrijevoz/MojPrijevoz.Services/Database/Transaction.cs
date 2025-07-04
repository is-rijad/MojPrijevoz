namespace MojPrijevoz.Services.Database;

public enum TransactionSide
{
    Credit = 0,
    Debit = 1
}
public class Transaction
{
    public int Id { get; set; }

    public int FareId { get; set; }

    public DateTime CreatedAt { get; set; }

    public TransactionSide Side { get; set; }

    public float Amount { get; set; }

    public DateTime? PostedAt { get; set; }

    public virtual Fare Fare { get; set; } = null!;
}