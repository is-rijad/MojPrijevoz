using System.ComponentModel.DataAnnotations.Schema;
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

    public User? User { get; set; }

    public ICollection<UserVehicle>? UserVehicles { get; set; }
    public ICollection<DriversDiscount>? DriversDiscounts { get; set; }

    [NotMapped] public ICollection<Rating>? RatingTos { get; set; }
}

public class UserProfileEntityConfiguration : IEntityTypeConfiguration<UserProfile>
{
    public void Configure(EntityTypeBuilder<UserProfile> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("UserProfile");

        entity.Property(e => e.ProfileType).IsRequired();

        entity.HasIndex(e => new { e.UserId, e.ProfileType }).IsUnique();

        entity.HasOne(d => d.User).WithMany()
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.ClientSetNull);
    }
}