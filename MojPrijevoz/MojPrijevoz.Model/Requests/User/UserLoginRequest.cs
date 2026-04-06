using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class UserLoginRequest {
    [Required][MaxLength(32)] public required string Username { get; set; }

    [Required] public required string Password { get; set; }
}