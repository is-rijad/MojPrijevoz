using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class UserInsertRequest {
    [Required][MaxLength(32)] public required string FirstName { get; set; }

    [Required][MaxLength(64)] public required string LastName { get; set; }

    [Required]
    [MaxLength(32)]
    [EmailAddress(ErrorMessage = "Email nije validan!")]
    public required string Email { get; set; }

    [Required][MaxLength(32)] public required string Username { get; set; }

    [Required] public required string Password { get; set; }
    [Required] public required string PasswordAgain { get; set; }

    [Required] public required int CityId { get; set; }
}