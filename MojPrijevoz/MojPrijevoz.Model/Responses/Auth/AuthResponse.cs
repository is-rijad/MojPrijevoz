namespace MojPrijevoz.Model.Responses.Auth;

public class AuthResponse
{
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String Email { get; set; }
    public String Username { get; set; }
    public String? Picture { get; set; }
}