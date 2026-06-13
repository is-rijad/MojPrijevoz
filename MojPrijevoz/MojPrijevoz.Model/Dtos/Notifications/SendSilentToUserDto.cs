namespace MojPrijevoz.Model.Dtos.Notifications;

public class SendSilentToUserDto
{
    public int UserId { get; set; }
    public IReadOnlyDictionary<string, string> Data { get; set; } = null!;

    public static readonly string LocationRequested = "LOCATION_REQUESTED";
}