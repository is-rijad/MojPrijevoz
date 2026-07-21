using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public abstract class BaseRequestChanges
{
    public int Id { get; set; }
    public required string Field { get; set; }
    public string? Note { get; set; }
    public bool IsEdited { get; set; } = false;
}

public class BaseRequestChangesEntityConfiguration<T> : IEntityTypeConfiguration<T> where T : BaseRequestChanges
{
    public virtual void Configure(EntityTypeBuilder<T> entity)
    {
        entity.HasKey(e => e.Id);


        entity.Property(it => it.Field).HasMaxLength(32);
        entity.Property(it => it.Note).IsRequired(false).HasMaxLength(64);
    }
}