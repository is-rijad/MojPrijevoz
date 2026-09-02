using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Dtos.Admin.Reports;

public class TransactionsReportDto : BaseReportDto
{
    public float Amount { get; set; }
    public TransactionSide Side { get; set; }
    public DateTime? RefundedAt { get; set; }
}
