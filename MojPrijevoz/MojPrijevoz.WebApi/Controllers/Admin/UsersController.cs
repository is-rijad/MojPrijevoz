using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.RequestChanges;
using MojPrijevoz.Model.Requests.Admin.User;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
    public class UsersController : ControllerBase {
        private readonly AdminUsersService _usersService;

        public UsersController(AdminUsersService usersService)
        {
            _usersService = usersService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] AdminUserSearchObject searchObject)
        {
            return Ok(await _usersService.GetAsync(searchObject));
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _usersService.GetByIdAsync(id));
        }
        [HttpPut("changes/{id}")]
        public async Task<IActionResult> RequestChanges(int id, [FromBody] RequestChangesRequest request)
        {
            return Ok(await _usersService.RequestChangesAsync(id, request));
        }
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] AdminUserUpdateRequest request) {
            return Ok(await _usersService.UpdateAsync(id, request));
        }
}

