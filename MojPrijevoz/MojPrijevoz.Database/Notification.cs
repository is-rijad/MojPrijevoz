using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MojPrijevoz.Database.Interfaces;

namespace MojPrijevoz.Database;

public enum NotificationType : short
{
    Default = 0
}

public class Notification : IHasCreatedAtTimestamp
{
    public int Id { get; set; }

    public string Message { get; set; } = null!;

    public NotificationType Type { get; set; }

    public bool IsRead { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class NotificationEntityConfiguration : IEntityTypeConfiguration<Notification>
{
    public void Configure(EntityTypeBuilder<Notification> entity)
    {
        entity.HasKey(e => e.Id);

        entity.ToTable("Notification");

        entity.Property(e => e.Message)
            .HasMaxLength(32)
            .IsUnicode(false);
    }
}