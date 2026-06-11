using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;


public class Notification : IHasCreatedAtTimestamp {
    public int Id { get; set; }
    public int UserId { get; set; }

    public string Message { get; set; } = null!;

    public string Type { get; set; } = null!;

    public bool IsRead { get; set; }
    public int? FareId { get; set; }
    public ProfileType? Side { get; set; }
    public int? RatingId { get; set; }

    public DateTime CreatedAt { get; set; }
    public User? User { get; set; }
}

public class NotificationEntityConfiguration : IEntityTypeConfiguration<Notification> {
    public void Configure(EntityTypeBuilder<Notification> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("Notifications");

        entity.Property(e => e.Message)
            .HasMaxLength(64)
            .IsUnicode(true);
        entity.Property(e => e.Type)
            .HasMaxLength(16)
            .IsUnicode(false);

        entity.HasOne(it => it.User).WithMany().HasForeignKey(it => it.UserId);
    }
}