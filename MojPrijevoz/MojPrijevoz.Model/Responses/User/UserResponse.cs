namespace MojPrijevoz.Model.Responses.User;

public class UserResponse
{
    public int Id { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string PhoneNumber { get; set; } = null!;
    public short Status { get; set; }
    public string? Picture { get; set; }
    public int CityId { get; set; }
}