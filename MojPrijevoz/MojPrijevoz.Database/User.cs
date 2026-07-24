using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public class User : Account, IEntityHasPicture
{
    public int CityId { get; set; }
    public required string PhoneNumber { get; set; }

    public virtual City? City { get; set; }
    public string? BankAccountNumber { get; set; }

    public ICollection<UserFcmToken>? UserFcmTokens { get; set; }
    public string? Picture { get; set; }
}

public class UserEntityConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> entity)
    {
        entity.ToTable("User");
        entity.HasBaseType<Account>();

        entity.Property(e => e.Picture)
            .HasMaxLength(256)
            .IsUnicode(false);

        entity.Property(e => e.PhoneNumber)
            .HasMaxLength(32)
            .IsUnicode();
        entity.Property(e => e.BankAccountNumber)
            .HasMaxLength(13)
            .IsRequired(false)
            .IsUnicode(false);

        entity.HasOne(d => d.City).WithMany(p => p.Users)
            .HasForeignKey(d => d.CityId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}