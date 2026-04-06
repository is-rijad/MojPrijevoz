using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.City;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CityController : ControllerBase {
    private readonly CityService _cityService;

    public CityController(CityService cityService) {
        _cityService = cityService;
    }

    [HttpGet]
    [AllowAnonymous]
    public async Task<IActionResult> Get([FromQuery] CitySearchObject search) {
        return Ok(await _cityService.GetAsync(search));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id) {
        return Ok(await _cityService.GetByIdAsync(id));
    }
}