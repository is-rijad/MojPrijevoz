using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Notifications;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FcmController : ControllerBase
{
    private readonly INotificationService _notificationService;

    public FcmController(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    [HttpPost]
    public async Task<IActionResult> UpdateFcmToken([FromBody] SubscribeToFcmRequest request)
    {
        await _notificationService.SubscribeToFcm(request);
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteFcmToken()
    {
        await _notificationService.UnsubscribeFromFcm();
        return Ok();
    }
}