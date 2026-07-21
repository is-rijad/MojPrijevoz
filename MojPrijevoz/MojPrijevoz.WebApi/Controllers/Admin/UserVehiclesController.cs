using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.RequestChanges;
using MojPrijevoz.Model.Requests.Admin.UserVehicle;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;

[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
public class UserVehiclesController : ControllerBase
{
    private readonly AdminUserVehiclesService _userVehiclesService;

    public UserVehiclesController(AdminUserVehiclesService userVehiclesService)
    {
        _userVehiclesService = userVehiclesService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] AdminUserVehicleSearchObject searchObject)
    {
        return Ok(await _userVehiclesService.GetAsync(searchObject));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        return Ok(await _userVehiclesService.GetByIdAsync(id));
    }

    [HttpPut("changes/{id}")]
    public async Task<IActionResult> RequestChanges(int id, [FromBody] RequestChangesRequest request)
    {
        return Ok(await _userVehiclesService.RequestChangesAsync(id, request));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] AdminUserVehicleUpdateRequest request)
    {
        return Ok(await _userVehiclesService.UpdateAsync(id, request));
    }
}