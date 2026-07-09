using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.Admin.Administrators;

public class AdminAllAdministratorsResponse
{
    public int Id { get; set; }
    public string Email { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public AccountStatus Status { get; set; }

    public AdministratorRole Role { get; set; }
}