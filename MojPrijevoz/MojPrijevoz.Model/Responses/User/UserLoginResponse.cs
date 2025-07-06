namespace MojPrijevoz.Model.Responses.User;

public class UserLoginResponse
{
    public required string Token { get; set; }
    public required int UserId { get; set; }
}