namespace MojPrijevoz.Model.Authorization;

public class UserInfoTokenDto
{
    public required string Username { get; set; }
    public required string Email { get; set; }
    public required int UserId { get; set; }
    public int? Role { get; set; }
}