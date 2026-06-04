using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
public class OkController : ControllerBase {
    private readonly INotificationService _notificationService;

    public OkController(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    [Route("api/ok")]
    [AllowAnonymous]
    [HttpGet]
    public async Task<IActionResult> OkEndpoint()
    {
        await _notificationService.SendToUserAsync(new SendToUserDto()
        {
            Body = "Testna notifikacija",
            Title = "Test",
            UserId = 51
        });
        return Ok();
    }
}