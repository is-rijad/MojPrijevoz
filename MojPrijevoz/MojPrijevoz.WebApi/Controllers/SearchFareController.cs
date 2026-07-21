using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.SearchFare;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SearchFareController : ControllerBase
{
    private readonly ISearchFareService _searchFareService;

    public SearchFareController(ISearchFareService searchFareService)
    {
        _searchFareService = searchFareService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] SearchFareSearchObject searchObject)
    {
        return Ok(await _searchFareService.Search(searchObject));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id, [FromQuery] SearchFareDriverSearchObject searchObject)
    {
        return Ok(await _searchFareService.SearchDriver(id, searchObject));
    }
}