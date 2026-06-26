
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class UserRequestChanges : BaseRequestChanges {
    public int UserId { get; set; }
    public User? User { get; set; }
}

public class UserRequestChangesEntityConfiguration : BaseRequestChangesEntityConfiguration<UserRequestChanges> {
    public override void Configure(EntityTypeBuilder<UserRequestChanges> entity)
    {
        base.Configure(entity);
        entity.ToTable("UserRequestChanges");
        entity.HasOne(it => it.User).WithMany().HasForeignKey(it => it.UserId);
    }
}
