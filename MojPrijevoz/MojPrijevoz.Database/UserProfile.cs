using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public enum ProfileType : short
{
    Passenger = 0,
    Driver = 1
}

public class UserProfile
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public ProfileType ProfileType { get; set; }

    public int NumberOfFares { get; set; }

    public virtual User? User { get; set; }

    public virtual ICollection<UserVehicle>? UserVehicles { get; set; }
    public virtual ICollection<DriversDiscount>? DriversDiscounts { get; set; }
    public virtual ICollection<Fare>? FareDrivers { get; set; }
    public virtual ICollection<Fare>? FarePassengers { get; set; }

    public virtual ICollection<Rating>? RatingFroms { get; set; }

    public virtual ICollection<Rating>? RatingTos { get; set; }
}

public class UserProfileEntityConfiguration : IEntityTypeConfiguration<UserProfile>
{
    public void Configure(EntityTypeBuilder<UserProfile> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("UserProfile");

        entity.Property(e => e.ProfileType).IsRequired();

        entity.HasIndex(e => new { e.UserId, e.ProfileType }).IsUnique();

        entity.HasOne(d => d.User).WithMany(p => p.UserProfiles)
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}