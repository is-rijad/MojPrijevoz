using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Dtos.Admin.Reports;

public class AllFaresReportDto : BaseReportDto
{
    public FareStatus Status { get; set; }
}