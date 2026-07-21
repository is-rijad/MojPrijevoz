using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using MojPrijevoz.Model.Dtos.FareLocation;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.InMemoryDatabase;
using MojPrijevoz.Services.SignalR.Hubs;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FareController : ControllerBase
{
    private readonly AuthorizationService _authorizationService;
    private readonly IMemoryCache _cache;
    private readonly IHubContext<SignalRHub> _fareLocationHubContext;
    private readonly IFareService _fareService;
    private readonly ConnectionTracker _tracker;

    public FareController(IFareService fareService,
        IHubContext<SignalRHub> fareLocationHubContext,
        IMemoryCache cache,
        ConnectionTracker tracker,
        AuthorizationService authorizationService)
    {
        _fareService = fareService;
        _fareLocationHubContext = fareLocationHubContext;
        _cache = cache;
        _tracker = tracker;
        _authorizationService = authorizationService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] FareSearchObject searchObject)
    {
        return Ok(await _fareService.GetAsync(searchObject));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        return Ok(await _fareService.GetByIdAsync(id));
    }


    [HttpPost("{id}/start")]
    public async Task<IActionResult> Start(int id)
    {
        return Ok(await _fareService.StartAsync(id));
    }

    [HttpGet("next")]
    public async Task<IActionResult> GetNextAcceptedFaresAsync([FromQuery] FareSearchObject searchObject)
    {
        return Ok(await _fareService.GetNextAcceptedFaresAsync(searchObject));
    }

    [HttpGet("{id}/rated")]
    public async Task<IActionResult> IsRatedAsync(int id)
    {
        return Ok(await _fareService.IsRatedAsync(id));
    }

    [HttpPost("location")]
    public async Task<IActionResult> SendLocation(FareLocationDto dto)
    {
        var senderId = _authorizationService.GetUserId();
        var connectionId = _tracker.Get(dto.UserId.ToString());

        if (connectionId != null)
        {
            dto.IsAccurate = true;
            _cache.Set(SignalRHub.GetCacheKey(senderId.ToString()), dto, SignalRHub.CacheTtl);
            await _fareLocationHubContext.Clients.Client(connectionId)
                .SendAsync("ReceiveLocation", dto);
        }

        return Ok();
    }
}