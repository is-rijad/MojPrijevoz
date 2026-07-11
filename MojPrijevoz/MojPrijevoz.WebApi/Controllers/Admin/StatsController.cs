using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;

[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
public class StatsController : ControllerBase
{
    private readonly AdminStatsService _adminStatsService;

    public StatsController(AdminStatsService adminStatsService)
    {
        _adminStatsService = adminStatsService;
    }

    [HttpGet("usersByCity")]

    public async Task<IActionResult> GetUsersByCity()
    {
        return Ok(await _adminStatsService.GetUsersByCityAsync());
    }


    [HttpGet("usersByMonth")]

    public async Task<IActionResult> GetUsersByMonth() {
        return Ok(await _adminStatsService.GetUsersByMonthAsync());
    }
    [HttpGet("revenueByMonth")]

    public async Task<IActionResult> GetRevenueByMonth() {
        return Ok(await _adminStatsService.GetRevenueByMonthAsync());
    }
    [HttpGet("allFaresThisMonth")]

    public async Task<IActionResult> GetAllFaresThisMonth() {
        return Ok(await _adminStatsService.GetAllFaresThisMonthAsync());
    }
}

