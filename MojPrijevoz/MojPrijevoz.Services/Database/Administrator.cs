namespace MojPrijevoz.Services.Database;

public enum AdministratorRole
{
    Moderator = 0,
    Admin = 1
}

public class Administrator : Account {
    public new int Id { get; set; }

    public AdministratorRole Role { get; set; }
}