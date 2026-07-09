using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.Administrators;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Route("api/admin/[controller]")]
    public class AdministratorController : ControllerBase {
        private readonly AdminAdministratorService _administratorService;

        public AdministratorController(AdminAdministratorService administratorService)
        {
            _administratorService = administratorService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] AdminAdministratorSearchObject searchObject)
        {
            return Ok(await _administratorService.GetAsync(searchObject));
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _administratorService.GetByIdAsync(id));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] AdminAdministratorUpsertRequest request) {
            return Ok(await _administratorService.UpdateAsync(id, request));
        }

        [HttpPost]
        public async Task<IActionResult> Insert([FromBody] AdminAdministratorUpsertRequest request) {
            return Ok(await _administratorService.InsertAsync(request));
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _administratorService.DeleteAsync(id);
            return Ok();
        }
}

