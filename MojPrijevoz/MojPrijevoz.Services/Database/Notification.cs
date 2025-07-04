using System;
using System.Collections.Generic;

namespace MojPrijevoz.Services.Database;

public partial class Notification
{
    public int Id { get; set; }

    public string Message { get; set; } = null!;

    public short Type { get; set; }

    public bool IsRead { get; set; }

    public DateTime CreatedAt { get; set; }
}
