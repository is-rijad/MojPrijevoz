namespace MojPrijevoz.Model.Dtos.Notifications;

public class SendSilentToUserDto
{
    public static readonly string LocationRequested = "LOCATION_REQUESTED";
    public int UserId { get; set; }
    public IReadOnlyDictionary<string, string> Data { get; set; } = null!;
}