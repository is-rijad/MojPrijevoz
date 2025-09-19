using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AuthorizationService _authorizationService;

    public AuthController(AuthorizationService authorizationService)
    {
        _authorizationService = authorizationService;
    }
    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        return Ok(await _authorizationService.GetByIdAsync(id));
    }
}