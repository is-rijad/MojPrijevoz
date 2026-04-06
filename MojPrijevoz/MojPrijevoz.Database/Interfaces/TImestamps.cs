namespace MojPrijevoz.Database.Interfaces;

public interface IHasCreatedAtTimestamp {
    public DateTime CreatedAt { get; set; }
}

public interface IHasTimestamps : IHasCreatedAtTimestamp {
    public DateTime? UpdatedAt { get; set; }
}