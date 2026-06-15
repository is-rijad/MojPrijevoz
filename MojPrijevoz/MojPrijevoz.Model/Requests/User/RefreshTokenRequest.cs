using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.User;

public class RefreshTokenRequest
{
    [Required] public required string AccessToken { get; set; }
    [Required] public required string RefreshToken { get; set; }
}