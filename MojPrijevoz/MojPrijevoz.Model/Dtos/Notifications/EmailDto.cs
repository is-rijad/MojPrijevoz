namespace MojPrijevoz.Model.Dtos.Notifications;

public class EmailDto {
    public EmailType Type { get; set; }
    public string To { get; set; } = null!;
    public string? Subject { get; set; }
    public IDictionary<string, dynamic> Data { get; set; } = null!;
}