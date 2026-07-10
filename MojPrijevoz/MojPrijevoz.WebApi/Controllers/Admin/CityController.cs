using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.City;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
    public class CityController : ControllerBase {
        private readonly AdminCityService _cityService;

        public CityController(AdminCityService cityService)
        {
            _cityService = cityService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] AdminCitySearchObject searchObject)
        {
            return Ok(await _cityService.GetAsync(searchObject));
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _cityService.GetByIdAsync(id));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] AdminCityUpsertRequest request) {
            return Ok(await _cityService.UpdateAsync(id, request));
        }

        [HttpPost]
        public async Task<IActionResult> Insert([FromBody] AdminCityUpsertRequest request) {
            return Ok(await _cityService.InsertAsync(request));
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _cityService.DeleteAsync(id);
            return Ok();
        }
}

