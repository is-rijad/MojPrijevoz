using System.ComponentModel.DataAnnotations;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Admin.UserVehicle;

public class AdminUserVehicleUpdateRequest
{
    [Required] public UserVehicleStatus Status { get; set; }
}