using Mapster;
using Microsoft.AspNetCore.Http;
using MojPrijevoz.Model.Requests.User;

namespace MojPrijevoz.Services.FormRequests.User;

public class UserUpdateFormRequest : UserUpdateRequest, IFormHasPicture
{
    [AdaptIgnore]
    public IFormFile? Picture { get; set; }
}