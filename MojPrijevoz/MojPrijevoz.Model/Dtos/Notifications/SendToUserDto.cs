namespace MojPrijevoz.Model.Dtos.Notifications;

public class SendToUserDto
{
    public static readonly string NewFareOfferType = "NEW_FARE_OFFER";
    public static readonly string AcceptedFareOfferType = "ACCEPTED_FARE_OFFER";
    public static readonly string RejectedFareOfferType = "REJECTED_FARE_OFFER";
    public static readonly string ExpiredFareOfferType = "EXPIRED_FARE_OFFER";
    public static readonly string PayedFareOfferType = "PAYED_FARE_OFFER";
    public static readonly string CompletedFareType = "COMPLETED_FARE";
    public static readonly string CancelledFareOfferType = "CANCELLED_FARE_OFFER";
    public static readonly string NewRatingType = "NEW_RATING";
    public static readonly string StartedFareType = "STARTED_FARE";
    public static readonly string ProximityNotificationType = "PROXIMITY_NOTIFICATION";
    public int UserId { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public IReadOnlyDictionary<string, string> Data { get; set; } = null!;
}