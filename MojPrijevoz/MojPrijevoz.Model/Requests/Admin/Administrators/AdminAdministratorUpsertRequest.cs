using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Requests.Admin.Administrators;

public class AdminAdministratorUpsertRequest {
    [Required][MaxLength(32)] public required string FirstName { get; set; }

    [Required][MaxLength(64)] public required string LastName { get; set; }
    [Required][MaxLength(32)] public required string Username { get; set; }

    [Required]
    [MaxLength(32)]
    [EmailAddress(ErrorMessage = "Email nije validan!")]

    public required string Email { get; set; }

    public bool ChangePassword { get; set; } = false;
    [Required]
    public AdministratorRole Role { get; set; }
    [Required]
    public AccountStatus Status { get; set; }
    [JsonIgnore] public string? PasswordHash { get; set; }
    [JsonIgnore] public string? PasswordSalt { get; set; }
}