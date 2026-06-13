using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase {
    private readonly INotificationService _notificationService;

    public OkController(INotificationService notificationService) {
        _notificationService = notificationService;
    }

    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> OkEndpoint() {
        await _notificationService.SendToUserAsync(new SendToUserDto()
        {
            UserId = 51,
            Title = "Nova ponuda vožnje",
            Body = $"Korisnik Rijad je poslao ponudu za vožnju",
            Data = new Dictionary<string, string>()
            {
                ["FareId"] = "1002",
                ["Type"] = SendToUserDto.NewFareOfferType,
                ["Side"] = "0"
            }
        });
        return Ok();
    }
}