using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Dtos.Admin.Reports;

public class RegisteredUsersReportDto : BaseReportDto
{
    public AccountStatus Status { get; set; }
}