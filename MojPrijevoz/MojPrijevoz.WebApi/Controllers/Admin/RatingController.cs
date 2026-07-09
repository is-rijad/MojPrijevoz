using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.Rating;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Route("api/admin/[controller]")]
    public class RatingController : ControllerBase {
        private readonly AdminRatingService _ratingService;

        public RatingController(AdminRatingService ratingService)
        {
            _ratingService = ratingService;
        }
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] AdminRatingSearchObject searchObject)
        {
            return Ok(await _ratingService.GetAsync(searchObject));
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _ratingService.GetByIdAsync(id));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] AdminRatingUpdateRequest request) {
            return Ok(await _ratingService.UpdateAsync(id, request));
        }

}

