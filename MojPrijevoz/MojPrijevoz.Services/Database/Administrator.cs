using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Services.Database;

public enum AdministratorRole : short
{
    Moderator = 0,
    Admin = 1
}

public class Administrator : Account
{
    public AdministratorRole Role { get; set; }
}

public class AdministratorEntityConfiguration : IEntityTypeConfiguration<Administrator>
{
    public void Configure(EntityTypeBuilder<Administrator> entity)
    {
        entity.ToTable("Administrator");
        entity.HasBaseType<Account>();
    }
}