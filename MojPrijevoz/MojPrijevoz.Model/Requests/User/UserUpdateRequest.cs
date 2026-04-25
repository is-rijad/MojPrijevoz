using MojPrijevoz.Database;
using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class UserUpdateRequest {
    [MaxLength(32)] public string? FirstName { get; set; }

    [MaxLength(64)] public string? LastName { get; set; }

    [MaxLength(32)]
    [EmailAddress(ErrorMessage = "Email nije validan!")]
    public string? Email { get; set; }

    [MaxLength(32)] public string? Username { get; set; }

    public string? OldPassword { get; set; }
    public string? Password { get; set; }
    public string? PasswordAgain { get; set; }

    public int? CityId { get; set; }
}