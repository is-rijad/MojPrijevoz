using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Services.Database;

public enum AccountStatus : short
{
    Banned = 0,
    Active = 1,
    WaitingForChanges = 2
}

public abstract class Account
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;
    public string PasswordSalt { get; set; } = null!;

    public DateTime RegisteredAt { get; set; }

    public AccountStatus Status { get; set; } = AccountStatus.Active;
}

public class AccountEntityConfiguration : IEntityTypeConfiguration<Account>
{
    public void Configure(EntityTypeBuilder<Account> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__Account__3214EC076FA573F4");

        entity.ToTable("Account");

        entity.HasIndex(e => e.Username, "UQ__Account__536C85E49E14A489").IsUnique();

        entity.HasIndex(e => e.Email, "UQ__Account__A9D10534BCB5A733").IsUnique();

        entity.Property(e => e.Email)
            .HasMaxLength(32)
            .IsUnicode(false);
        entity.Property(e => e.FirstName)
            .HasMaxLength(32)
            .IsUnicode(false);
        entity.Property(e => e.LastName)
            .HasMaxLength(64)
            .IsUnicode(false);
        entity.Property(e => e.PasswordHash)
            .HasMaxLength(44)
            .IsUnicode(false)
            .IsFixedLength();
        entity.Property(e => e.PasswordSalt)
            .HasMaxLength(24)
            .IsUnicode(false)
            .IsFixedLength();
        entity.Property(e => e.Username)
            .HasMaxLength(32)
            .IsUnicode(false);
        entity.Property(e => e.RegisteredAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}