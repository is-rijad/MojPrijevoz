using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Model.Requests.Admin.Report;

public class AdminReportRequest
{
    [Required] public ReportType Type { get; set; }
    [Required] public ReportPeriod Period { get; set; }
    public DateTime? From { get; set; }
    public DateTime? To { get; set; }
}