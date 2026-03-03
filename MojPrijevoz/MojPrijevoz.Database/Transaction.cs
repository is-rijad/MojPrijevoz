using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum TransactionSide : short
{
    Credit = 0,
    Debit = 1
}

public class Transaction : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public int FareId { get; set; }

    public TransactionSide Side { get; set; }

    public float Amount { get; set; }

    public DateTime? PostedAt { get; set; }

    public virtual Fare? Fare { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class TransactionEntityConfiguration : IEntityTypeConfiguration<Transaction>
{
    public void Configure(EntityTypeBuilder<Transaction> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("Transaction");

        entity.HasOne(d => d.Fare).WithMany(p => p.Transactions)
            .HasForeignKey(d => d.FareId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}