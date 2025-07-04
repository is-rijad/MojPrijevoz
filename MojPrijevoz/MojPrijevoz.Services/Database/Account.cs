namespace MojPrijevoz.Services.Database;

public enum AccountStatus
{
    Banned = 0,
    Active = 1,
    WaitingForChanges = 2,
}

public class Account
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string Password { get; set; } = null!;

    public DateTime RegisteredAt { get; set; }

    public AccountStatus Status { get; set; }
}