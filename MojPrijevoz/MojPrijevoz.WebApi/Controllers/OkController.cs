using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Exceptions;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase
{
    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public IActionResult OkEndpoint()
    {
        throw new Exception("This is a bad request example.");
    }
}