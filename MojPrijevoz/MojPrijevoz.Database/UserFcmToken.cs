using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class UserFcmToken
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Token { get; set; } = null!;
    public string Platform { get; set; } = null!;
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public User? User { get; set; }
}

public class UserFcmTokenEntityConfiguration : IEntityTypeConfiguration<UserFcmToken>
{
    public void Configure(EntityTypeBuilder<UserFcmToken> entity)
    {
        entity.ToTable("UserFcmTokens");
        entity.HasKey(e => e.Id);
        entity.Property(e => e.Token)
            .HasMaxLength(256)
            .IsUnicode();
        entity.Property(e => e.Platform)
            .HasMaxLength(8)
            .IsUnicode(false);
        entity.HasOne(d => d.User).WithMany(p => p.UserFcmTokens)
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.ClientSetNull);

        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
        entity.Property(e => e.UpdatedAt).ValueGeneratedOnAddOrUpdate()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
    }
}