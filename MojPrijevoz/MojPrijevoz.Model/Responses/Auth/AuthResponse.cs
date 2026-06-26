namespace MojPrijevoz.Model.Responses.Auth;

public class AuthResponse {
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string Email { get; set; }
    public required string Username { get; set; }
    public string? Picture { get; set; }
}