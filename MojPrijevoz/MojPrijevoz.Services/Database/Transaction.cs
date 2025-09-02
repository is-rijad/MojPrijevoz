using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Services.Database;

public enum TransactionSide : short
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

public class TransactionEntityConfiguration : IEntityTypeConfiguration<Transaction>
{
    public void Configure(EntityTypeBuilder<Transaction> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__Transact__3214EC071B4CE3F1");

        entity.ToTable("Transaction");

        entity.HasOne(d => d.Fare).WithMany(p => p.Transactions)
            .HasForeignKey(d => d.FareId)
            .OnDelete(DeleteBehavior.ClientSetNull)
            .HasConstraintName("FK_Transaction_Fare");

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}