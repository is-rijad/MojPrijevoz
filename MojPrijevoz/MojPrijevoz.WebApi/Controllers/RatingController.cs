using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Rating;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Rating;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RatingController : ControllerBase
{
    private readonly IRatingService _ratingService;

    public RatingController(IRatingService ratingService)
    {
        _ratingService = ratingService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] RatingSearchObject searchObject)
    {
        return Ok(await _ratingService.GetAsync(searchObject));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id) {
        return Ok(await _ratingService.GetByIdAsync(id));
    }


    [HttpPost]
    public async Task<IActionResult> Post(RatingInsertRequest request) {
        return Ok(await _ratingService.InsertAsync(request));
    }
}