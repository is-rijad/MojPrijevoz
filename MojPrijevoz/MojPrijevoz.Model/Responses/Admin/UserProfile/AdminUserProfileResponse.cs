using MojPrijevoz.Model.Responses.Admin.User;

namespace MojPrijevoz.Model.Responses.Admin.UserProfile;

public class AdminUserProfileResponse
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public AdminUsersResponse? User { get; set; }
}