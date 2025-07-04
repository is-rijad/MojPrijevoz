using System;
using System.Collections.Generic;

namespace MojPrijevoz.Services.Database;

public partial class FareOffer
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int PassengerId { get; set; }

    public short Side { get; set; }

    public float Budget { get; set; }

    public int VehicleId { get; set; }

    public DateTime CreatedAt { get; set; }

    public int OriginCityId { get; set; }

    public int DestinationCityId { get; set; }

    public virtual City DestinationCity { get; set; } = null!;

    public virtual User Driver { get; set; } = null!;

    public virtual ICollection<Fare> Fares { get; set; } = new List<Fare>();

    public virtual City OriginCity { get; set; } = null!;

    public virtual User Passenger { get; set; } = null!;

    public virtual UserVehicle Vehicle { get; set; } = null!;
}
