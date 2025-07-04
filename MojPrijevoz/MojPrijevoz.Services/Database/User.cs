namespace MojPrijevoz.Services.Database;

public class User : Account
{
    public new int Id { get; set; }

    public string? Picture { get; set; }

    public int CityId { get; set; }

    public virtual City City { get; set; } = null!;

    public virtual ICollection<Fare> FareDrivers { get; set; } = new List<Fare>();

    public virtual ICollection<FareOffer> FareOfferDrivers { get; set; } = new List<FareOffer>();

    public virtual ICollection<FareOffer> FareOfferPassengers { get; set; } = new List<FareOffer>();

    public virtual ICollection<Fare> FarePassengers { get; set; } = new List<Fare>();

    public virtual ICollection<Rating> RatingFroms { get; set; } = new List<Rating>();

    public virtual ICollection<Rating> RatingTos { get; set; } = new List<Rating>();

    public virtual ICollection<UserProfile> UserProfiles { get; set; } = new List<UserProfile>();
}