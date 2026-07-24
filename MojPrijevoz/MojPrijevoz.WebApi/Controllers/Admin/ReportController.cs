using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.Report;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;

[ApiController]
[Authorize(Roles = "0,1")]
[Route("api/admin/[controller]")]
public class ReportController : ControllerBase
{
    private readonly AdminReportService _reportService;

    public ReportController(AdminReportService reportService)
    {
        _reportService = reportService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] AdminReportRequest request)
    {
        return File(await _reportService.GetReport(request), "application/pdf");
    }
}