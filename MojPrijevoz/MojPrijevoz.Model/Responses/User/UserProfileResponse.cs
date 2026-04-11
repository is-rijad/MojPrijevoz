using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.User;

public class UserProfileResponse
{
    public int Id { get; set; }
    public int NumberOfFares { get; set; }
    public short ProfileType { get; set; }
    public int UserId { get; set; }
    public UserResponse? User { get; set; }
}