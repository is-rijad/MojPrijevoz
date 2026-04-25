using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;


public class User : Account {
    public string? Picture { get; set; }

    public int CityId { get; set; }

    public virtual City? City { get; set; }


    public virtual ICollection<UserProfile>? UserProfiles { get; set; }
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