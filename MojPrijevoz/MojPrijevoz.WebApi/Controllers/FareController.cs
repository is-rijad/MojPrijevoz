using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Fare;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FareController : ControllerBase {
    private readonly IFareService _fareService;

    public FareController(IFareService fareService) {
        _fareService = fareService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] FareSearchObject searchObject) {
        return Ok(await _fareService.GetAsync(searchObject));
    }


    [HttpPost("{id}/start")]
    public async Task<IActionResult> Start(int id) {
        return Ok(await _fareService.StartAsync(id));
    }
    [HttpGet("next")]
    public async Task<IActionResult> GetNextAcceptedFaresAsync([FromQuery] FareSearchObject searchObject) {
        return Ok(await _fareService.GetNextAcceptedFaresAsync(searchObject));
    }
}