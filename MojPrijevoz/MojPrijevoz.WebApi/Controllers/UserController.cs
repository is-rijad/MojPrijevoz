using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.FormRequests.User;
using MojPrijevoz.Services.User;
using MojPrijevoz.WebApi.Filters;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase {
    private readonly AuthorizationService _authorizationService;
    private readonly UserService _userService;

    public UserController(UserService userService,
        AuthorizationService authorizationService) {
        _userService = userService;
        _authorizationService = authorizationService;
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<IActionResult> Post([FromBody] UserInsertRequest request) {
        return Ok(await _userService.InsertWithTransactionAsync(request));
    }

    [HttpPost("reset-password/code")]
    [AllowAnonymous]
    public async Task<IActionResult> RequestResetPassword([FromBody] RequestResetPasswordRequest request) {
        return Ok(await _userService.RequestResetPasswordCode(request));
    }

    [HttpPost("reset-password")]
    [AllowAnonymous]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request) {
        await _userService.ResetPassword(request);
        return Ok();
    }


    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id) {
        return Ok(await _userService.GetByIdAsync(id));
    }

    [HttpPut("{id}")]
    [ImageSizeFilter]
    public async Task<IActionResult> Put(int id, [FromForm] UserUpdateFormRequest request) {
        return Ok(await _userService.UpdateAsync(id, request));
    }
}