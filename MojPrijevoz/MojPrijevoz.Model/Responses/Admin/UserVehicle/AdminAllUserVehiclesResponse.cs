using MojPrijevoz.Database;
using MojPrijevoz.Model.Responses.Admin.UserProfile;
using MojPrijevoz.Model.Responses.Admin.Vehicle;

namespace MojPrijevoz.Model.Responses.Admin.UserVehicle;

public class AdminAllUserVehiclesResponse
{
    public int Id { get; set; }
    public int VehicleId { get; set; }
    public int ProfileId { get; set; }

    public int ModelYear { get; set; }

    public string LicensePlate { get; set; } = null!;

    public float PricePerKm { get; set; }

    public UserVehicleStatus Status { get; set; }
    public AdminVehicleResponse? Vehicle { get; set; }
    public AdminUserProfileResponse? Profile { get; set; }
}