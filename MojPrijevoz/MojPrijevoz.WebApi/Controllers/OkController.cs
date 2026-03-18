using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase
{


    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public Task<IActionResult> OkEndpoint()
    {
        return Task.FromResult<IActionResult>(Ok());
    }
}