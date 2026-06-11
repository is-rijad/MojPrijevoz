namespace MojPrijevoz.Model.Dtos.Notifications;

public class SendToUserDto
{
    public int UserId { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public IReadOnlyDictionary<string, string> Data { get; set; } = null!;

    public static readonly string NewFareOfferType = "NEW_FARE_OFFER";
    public static readonly string AcceptedFareOfferType = "ACCEPTED_FARE_OFFER";
    public static readonly string RejectedFareOfferType = "REJECTED_FARE_OFFER";
    public static readonly string ExpiredFareOfferType = "EXPIRED_FARE_OFFER";
    public static readonly string PayedFareOfferType = "PAYED_FARE_OFFER";
    public static readonly string NewRatingType = "NEW_RATING";
}