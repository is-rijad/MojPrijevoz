using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class RequestResetPasswordRequest
{
    [Required] public string Email { get; set; } = null!;
}