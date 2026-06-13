namespace MojPrijevoz.Model.Responses.Stripe;

public class StripeHandleResponse {
    public int Id { get; set; }
    public string ClientSecret { get; set; } = null!;
}