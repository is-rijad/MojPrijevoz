using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Admin.Users;

public class UsersResponse
{
    public int Id { get; set; }
    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Username { get; set; } = null!;
    public AccountStatus Status { get; set; }
    public string PhoneNumber { get; set; } = null!;
    public DateTime RegisteredAt { get; set; }
}