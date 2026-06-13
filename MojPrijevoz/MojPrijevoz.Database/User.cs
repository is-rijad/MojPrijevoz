using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;


public class User : Account, IEntityHasPicture {
    public string? Picture { get; set; }

    public int CityId { get; set; }

    public virtual City? City { get; set; }


    public ICollection<UserFcmToken>? UserFcmTokens { get; set; }
}

public class UserEntityConfiguration : IEntityTypeConfiguration<User> {
    public void Configure(EntityTypeBuilder<User> entity) {
        entity.ToTable("User");
        entity.HasBaseType<Account>();

        entity.Property(e => e.Picture)
            .HasMaxLength(256)
            .IsUnicode(false);

        entity.HasOne(d => d.City).WithMany(p => p.Users)
            .HasForeignKey(d => d.CityId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}