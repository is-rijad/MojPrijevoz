using Microsoft.AspNetCore.Mvc;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase
{
    [Route("api/ok")]
    [HttpGet]
    public IActionResult OkEndpoint()
    {
        return Ok("OK");
    }
}