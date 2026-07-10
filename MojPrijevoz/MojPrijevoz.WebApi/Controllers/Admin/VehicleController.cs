using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.Vehicle;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
    public class VehicleController : ControllerBase {
        private readonly AdminVehicleService _vehicleService;

        public VehicleController(AdminVehicleService vehicleService)
        {
            _vehicleService = vehicleService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] AdminVehicleSearchObject searchObject)
        {
            return Ok(await _vehicleService.GetAsync(searchObject));
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _vehicleService.GetByIdAsync(id));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] AdminUpsertVehicleRequest request) {
            return Ok(await _vehicleService.UpdateAsync(id, request));
        }

        [HttpPost]
        public async Task<IActionResult> Insert([FromBody] AdminUpsertVehicleRequest request) {
            return Ok(await _vehicleService.InsertAsync(request));
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _vehicleService.DeleteAsync(id);
            return Ok();
        }
}

