using System;
using System.Collections.Generic;

namespace MojPrijevoz.Services.Database;

public partial class Rating
{
    public int Id { get; set; }

    public int FromId { get; set; }

    public int ToId { get; set; }

    public string? Comment { get; set; }

    public short Grade { get; set; }

    public DateTime CreatedAt { get; set; }

    public int FareId { get; set; }

    public virtual Fare Fare { get; set; } = null!;

    public virtual User From { get; set; } = null!;

    public virtual User To { get; set; } = null!;
}
