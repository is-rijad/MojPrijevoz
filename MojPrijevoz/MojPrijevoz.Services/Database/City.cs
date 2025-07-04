namespace MojPrijevoz.Services.Database;

public class City
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;

    public DateTime UpdatedAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Fare> FareDestinationCities { get; set; } = new List<Fare>();

    public virtual ICollection<FareOffer> FareOfferDestinationCities { get; set; } = new List<FareOffer>();

    public virtual ICollection<FareOffer> FareOfferOriginCities { get; set; } = new List<FareOffer>();

    public virtual ICollection<Fare> FareOriginCities { get; set; } = new List<Fare>();

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}