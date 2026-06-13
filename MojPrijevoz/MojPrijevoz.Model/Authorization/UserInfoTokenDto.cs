namespace MojPrijevoz.Model.Authorization;

public class UserInfoTokenDto {
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required int Id { get; set; }
    public required int PassengerProfileId { get; set; }
    public required short Status { get; set; }
    public int? DriverProfileId { get; set; }
    public string? Picture { get; set; }
    public int? Role { get; set; }
}