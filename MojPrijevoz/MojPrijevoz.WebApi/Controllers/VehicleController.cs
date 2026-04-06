using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Vehicle;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class VehicleController : ControllerBase {
    private readonly VehicleService _vehicleService;

    public VehicleController(VehicleService vehicleService) {
        _vehicleService = vehicleService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] VehicleSearchObject search) {
        return Ok(await _vehicleService.GetAsync(search));
    }
}