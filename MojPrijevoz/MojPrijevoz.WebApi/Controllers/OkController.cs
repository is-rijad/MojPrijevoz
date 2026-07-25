using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase
{
    private readonly IHostEnvironment _env;

    public OkController(IHostEnvironment env)
    {
        _env = env;
    }

    // Health-check endpoint for my k3s home lab
    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public IActionResult OkEndpoint()
    {
        if (_env.IsDevelopment()) {
            return Ok();
        }

        return NotFound("Only for development");
    }
}