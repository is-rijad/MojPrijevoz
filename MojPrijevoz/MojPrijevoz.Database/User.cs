using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public enum Gender : short
{
    Female = 0,
    Male = 1
}

public class User : Account
{
    public string? Picture { get; set; }

    public int CityId { get; set; }

    public virtual City? City { get; set; }
    public Gender? Gender { get; set; }

    public virtual ICollection<Fare>? FareDrivers { get; set; }

    public virtual ICollection<Fare>? FarePassengers { get; set; }

    public virtual ICollection<Rating>? RatingFroms { get; set; }

    public virtual ICollection<Rating>? RatingTos { get; set; }

    public virtual ICollection<UserProfile>? UserProfiles { get; set; }
}

public class UserEntityConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> entity)
    {
        entity.ToTable("User");
        entity.HasBaseType<Account>();

        entity.Property(e => e.Picture)
            .HasMaxLength(64)
            .IsUnicode(false);

        entity.HasOne(d => d.City).WithMany(p => p.Users)
            .HasForeignKey(d => d.CityId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}