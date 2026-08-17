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
    private readonly ILogger _logger;

    public RecommenderController(RecommenderService recommender, IHostEnvironment env, ILogger logger)
    {
        _recommender = recommender;
        _env = env;
        _logger = logger;
    }

    [HttpGet]
    public async Task<IActionResult> GetRecommendedRoutes([FromQuery] RecommendedDriversSearchObject searchObject)
    {
        return Ok(await _recommender.RecommendDriversAsync(searchObject));
    }

    [HttpPost("retrain")]
    [AllowAnonymous]
    public  IActionResult Retrain()
    {
        if (!_env.IsDevelopment())
            return NotFound("Only for development");

        _ = Task.Run(async () =>
        {
            try { await _recommender.TrainAsync(); }
            catch (Exception ex) { _logger.LogError(ex, "Retrain failed."); }
        });

        return Ok("Model is being retrained in background");
    }
}