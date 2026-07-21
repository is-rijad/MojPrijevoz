using Mapster;
using Microsoft.AspNetCore.Http;
using MojPrijevoz.Model.Requests.UserVehicle;

namespace MojPrijevoz.Services.FormRequests.UserVehicle;

public class UserVehicleUpsertFormRequest : UserVehicleUpsertRequest, IFormHasPicture
{
    [AdaptIgnore] public IFormFile? Picture { get; set; }
}