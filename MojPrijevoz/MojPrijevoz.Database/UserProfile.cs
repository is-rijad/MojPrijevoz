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
}

public class UserProfileEntityConfiguration : IEntityTypeConfiguration<UserProfile>
{
    public void Configure(EntityTypeBuilder<UserProfile> entity)
    {
        entity.HasKey(e => e.Id).HasName("PK__UserProf__3214EC079A04CFBD");

        entity.ToTable("UserProfile");

        entity.Property(e => e.ProfileType).IsRequired();

        entity.HasIndex(e => new { e.UserId, e.ProfileType }, "UQ_UserProfile").IsUnique();

        entity.HasOne(d => d.User).WithMany(p => p.UserProfiles)
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.ClientSetNull)
            .HasConstraintName("FK_UserProfile_User");
    }
}