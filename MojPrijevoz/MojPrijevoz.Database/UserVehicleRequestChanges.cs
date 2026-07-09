using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class UserVehicleRequestChanges : BaseRequestChanges {
    public int UserVehicleId { get; set; }
    public UserVehicle? UserVehicle { get; set; }
}

public class UserVehicleRequestChangesEntityConfiguration : BaseRequestChangesEntityConfiguration<UserVehicleRequestChanges> {
    public override void Configure(EntityTypeBuilder<UserVehicleRequestChanges> entity)
    {
        base.Configure(entity);
        entity.ToTable("UserVehicleRequestChanges");
        entity.HasOne(it => it.UserVehicle).WithMany().HasForeignKey(it => it.UserVehicleId);
    }
}
