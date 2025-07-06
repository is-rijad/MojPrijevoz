using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class UserInsertRequest
{
    [Required] [MaxLength(32)] public string FirstName { get; set; } = null!;

    [Required] [MaxLength(64)] public string LastName { get; set; } = null!;

    [Required]
    [MaxLength(32)]
    [EmailAddress]
    public string Email { get; set; } = null!;

    [Required] [MaxLength(32)] public string Username { get; set; } = null!;

    [Required] public string Password { get; set; } = null!;

    // public string? Picture { get; set; }
    [Required] public int CityId { get; set; }
}