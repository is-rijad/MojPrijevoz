using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class RefreshToken
{
    public int Id { get; set; }
    public string TokenHash { get; set; } = null!;
    public string TokenSalt { get; set; } = null!;
    public int UserId { get; set; }

    public Account? User { get; set; } = null!;
}
public class RefreshTokenEntityConfiguration : IEntityTypeConfiguration<RefreshToken> {
    public void Configure(EntityTypeBuilder<RefreshToken> builder) {
        builder.ToTable("RefreshTokens");
        builder.HasKey(rt => rt.Id);
        builder.Property(rt => rt.TokenHash)
            .IsRequired();
        builder.Property(rt => rt.TokenSalt)
            .IsRequired();
        builder.HasOne(rt => rt.User)
            .WithMany()
            .HasForeignKey(rt => rt.UserId)
            .OnDelete(DeleteBehavior.NoAction);
    }
}