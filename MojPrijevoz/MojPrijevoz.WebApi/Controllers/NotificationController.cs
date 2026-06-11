using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase {
    private readonly INotificationService _notificationService;

    public NotificationController(INotificationService notificationService) {
        _notificationService = notificationService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] NotificationSearchObject search) {
        return Ok(await _notificationService.GetAsync(search));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id)
    {
        await _notificationService.MarkAsReadAsync(id);
        return Ok();
    }
}