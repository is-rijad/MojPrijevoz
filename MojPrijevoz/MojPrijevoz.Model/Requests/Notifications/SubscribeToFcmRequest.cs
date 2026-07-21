using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Notifications;

public class SubscribeToFcmRequest
{
    [Required] public string Token { get; set; } = null!;

    [Required] public string Platform { get; set; } = null!;
}