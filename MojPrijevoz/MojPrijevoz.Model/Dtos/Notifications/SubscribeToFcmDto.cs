using MojPrijevoz.Model.Requests.Notifications;

namespace MojPrijevoz.Model.Dtos.Notifications;

public class SubscribeToFcmDto : SubscribeToFcmRequest {
    public int UserId { get; set; }
}