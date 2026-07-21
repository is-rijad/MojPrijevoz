using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Services.FareOffer;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FareOfferController : ControllerBase
{
    private readonly IFareOfferService _fareOfferService;

    public FareOfferController(IFareOfferService fareOfferService)
    {
        _fareOfferService = fareOfferService;
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] FareOfferInsertRequest request)
    {
        return Ok(await _fareOfferService.InsertWithTransactionAsync(request));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, [FromBody] FareOfferUpdateRequest request)
    {
        return Ok(await _fareOfferService.UpdateWithTransactionAsync(id, request));
    }


    [HttpPost("{id}/accept")]
    public async Task<IActionResult> Accept(int id)
    {
        return Ok(await _fareOfferService.AcceptOfferAsync(id));
    }

    [HttpPost("{id}/reject")]
    public async Task<IActionResult> Reject(int id)
    {
        return Ok(await _fareOfferService.RejectOfferAsync(id));
    }

    [HttpPost("{id}/cancel")]
    public async Task<IActionResult> Cancel(int id)
    {
        return Ok(await _fareOfferService.CancelOfferAsync(id));
    }

    [HttpGet("{id}/allowed")]
    public async Task<IActionResult> Allowed(int id)
    {
        return Ok(await _fareOfferService.AllowedActions(id));
    }
}