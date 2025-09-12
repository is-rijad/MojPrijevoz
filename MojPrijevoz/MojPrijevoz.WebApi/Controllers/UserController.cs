using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Services.User;
using IAuthorizationService = MojPrijevoz.Services.Authorization.IAuthorizationService;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly UserService _userService;
    private readonly IAuthorizationService _authorizationService;

    public UserController(UserService userService,
        IAuthorizationService authorizationService)
    {
        _userService = userService;
        _authorizationService = authorizationService;
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<IActionResult> Post([FromBody] UserInsertRequest request)
    {
        await _userService.InsertAsync(request);
        return Ok("Registracija uspješna.");
    }


    [HttpPost("[action]")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
    {
        return Ok(await _authorizationService.Login(request));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id,[FromBody] UserUpdateRequest request) {
        return Ok(await _userService.UpdateAsync(id, request));
    }
}