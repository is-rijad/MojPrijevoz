using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Services.UserProfile;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserProfileController : ControllerBase {
    private readonly UserProfileService _userProfileService;

    public UserProfileController(UserProfileService userProfileService) {
        _userProfileService = userProfileService;
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id) {
        return Ok(await _userProfileService.GetByIdAsync(id));
    }
}