using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Services.FareOffer;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FareOfferController : ControllerBase
{
    private readonly FareOfferService _fareOfferService;

    public FareOfferController(FareOfferService fareOfferService)
    {
        _fareOfferService = fareOfferService;
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] FareOfferInsertRequest request) {
        return Ok(await _fareOfferService.InsertWithTransactionAsync(request));
    }
}