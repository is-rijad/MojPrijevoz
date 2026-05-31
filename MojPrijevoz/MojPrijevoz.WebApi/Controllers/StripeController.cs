using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Responses.Stripe;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StripeController : ControllerBase {
    private readonly IPaymentService<StripeHandleRequest, StripeHandleResponse> _stripePaymentService;

    public StripeController(IPaymentService<StripeHandleRequest, StripeHandleResponse> stripePaymentService)
    {
        _stripePaymentService = stripePaymentService;
    }
    [HttpPost("CreateIntent")]
    public async Task<IActionResult> CreateIntent([FromBody] StripeHandleRequest request) {
        return Ok(await _stripePaymentService.Handle(request));
    }

    [HttpPost("Webhook")]
    [AllowAnonymous]
    public async Task<IActionResult> Webhook()
    {
        await _stripePaymentService.Webhook();
        return Ok();
    }
}