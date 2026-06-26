using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Admin.User;

public class AdminUserUpdateRequest
{
    public AccountStatus Status { get; set; }
}