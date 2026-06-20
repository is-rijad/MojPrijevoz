using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase {

    public OkController()
    {
    }

    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> OkEndpoint()
    {
        return Ok();
    }
}