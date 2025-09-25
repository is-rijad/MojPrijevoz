using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Services.City;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase
{
    private readonly AdminCityService _cityService;

    public OkController(AdminCityService cityService)
    {
        _cityService = cityService;
    }

    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> OkEndpoint()
    {
        var city = await _cityService.GetByIdAsync(73);
        return Ok(city);
    }
}