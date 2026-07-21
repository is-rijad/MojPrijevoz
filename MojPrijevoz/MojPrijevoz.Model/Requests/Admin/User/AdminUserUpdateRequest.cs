using System.ComponentModel.DataAnnotations;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Admin.User;

public class AdminUserUpdateRequest
{
    [Required] public AccountStatus Status { get; set; }
}