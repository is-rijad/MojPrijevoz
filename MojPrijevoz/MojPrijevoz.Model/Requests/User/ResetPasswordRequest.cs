using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class ResetPasswordRequest
{
    [Required] public string Email { get; set; } = null!;

    [Required] public string Code { get; set; } = null!;

    [Required] public string Password { get; set; } = null!;

    [Required] public string PasswordAgain { get; set; } = null!;
}