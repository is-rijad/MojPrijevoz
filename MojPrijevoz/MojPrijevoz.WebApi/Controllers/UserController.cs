using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.User;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly AuthorizationService _authorizationService;
    private readonly UserService _userService;

    public UserController(UserService userService,
        AuthorizationService authorizationService)
    {
        _userService = userService;
        _authorizationService = authorizationService;
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<IActionResult> Post([FromBody] UserInsertRequest request)
    {
        return Ok(await _userService.InsertWithTransactionAsync(request));
    }


    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        return Ok(await _userService.GetByIdAsync(id));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, [FromBody] UserUpdateRequest request)
    {
        return Ok(await _userService.UpdateAsync(id, request));
    }
}