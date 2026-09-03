namespace MojPrijevoz.Model.Dtos.Admin.Reports;

public class FareByUserReportDto : BaseReportDto
{
    public int UserId { get; set; }
    public string UserName { get; set; } = null!;
}
