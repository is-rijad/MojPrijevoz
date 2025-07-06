using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Services.User;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase {
    private readonly IUserService _userService;

    public UserController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<IActionResult> CreateUser([FromBody] UserInsertRequest request)
    {
        await _userService.CreateUser(request);
        return Ok("Registracija uspješna.");
    }


    [HttpPost("[action]")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] UserLoginRequest request) {
        return Ok(await _userService.Login(request));
    }
}