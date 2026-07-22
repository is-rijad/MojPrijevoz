using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Recommender;


namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RecommenderController : ControllerBase
{
    private readonly IHostEnvironment _env;
    private readonly RecommenderService _recommender;

    public RecommenderController(RecommenderService recommender, IHostEnvironment env)
    {
        _recommender = recommender;
        _env = env;
    }

    [HttpGet]
    public async Task<IActionResult> GetRecommendedRoutes([FromQuery] RecommendedDriversSearchObject searchObject)
    {
        return Ok(await _recommender.RecommendDriversAsync(searchObject));
    }

    [HttpPost("retrain")]
    [AllowAnonymous]
    public async Task<IActionResult> RetrainAsync()
    {
        if (_env.IsDevelopment())
        {
            await _recommender.LoadOrTrainAsync();
            await _recommender.TrainAsync();
            return Ok("Model is being retrained in background");
        }

        return NotFound("Only for development");
    }
}