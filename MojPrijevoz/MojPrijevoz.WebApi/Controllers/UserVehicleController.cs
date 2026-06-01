using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.UserVehicle;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.FormRequests.UserVehicle;
using MojPrijevoz.Services.UserVehicle;

[ApiController]
[Route("api/[controller]")]
public class UserVehicleController : ControllerBase {
    private readonly UserVehicleService _userVehicleService;

    public UserVehicleController(UserVehicleService userVehicleService) {
        _userVehicleService = userVehicleService;
    }

    [HttpPost]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> Post([FromForm] UserVehicleUpsertFormRequest request) {
        return Ok(await _userVehicleService.InsertWithTransactionAsync(request));
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] UserVehicleSearchObject searchObject) {
        return Ok(await _userVehicleService.GetAsync(searchObject));
    }


    [HttpPut("{id}")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> Put(int id, [FromForm] UserVehicleUpsertFormRequest request) {
        return Ok(await _userVehicleService.UpdateAsync(id, request));
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id) {
        await _userVehicleService.DeleteAsync(id);
        return Ok();
    }
}