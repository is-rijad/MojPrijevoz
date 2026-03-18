using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.UserVehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.UserVehicle;

[ApiController]
[Route("api/[controller]")]
public class UserVehicleController : ControllerBase
{
    private readonly UserVehicleService _userVehicleService;

    public UserVehicleController(UserVehicleService userVehicleService)
    {
        _userVehicleService = userVehicleService;
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] UserVehicleUpsertRequest request)
    {
        return Ok(await _userVehicleService.InsertWithTransactionAsync(request));
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] UserVehicleSearchObject searchObject)
    {
        return Ok(await _userVehicleService.GetAsync(searchObject));
    }


    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, [FromBody] UserVehicleUpsertRequest request)
    {
        return Ok(await _userVehicleService.UpdateAsync(id, request));
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _userVehicleService.DeleteAsync(id);
        return Ok();
    }
}