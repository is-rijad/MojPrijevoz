using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Admin.Reports;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.Report;
using MojPrijevoz.Services.Helpers;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace MojPrijevoz.Services.Admin;

public class AdminReportService
{
    private readonly MojPrijevozDbContext _dbContext;

    public AdminReportService(MojPrijevozDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<byte[]> GetReport(AdminReportRequest request)
    {
        ValidateRequest(request);
        using var stream = new MemoryStream();
        var queryable = GetQuerySet(request);
        return await GenerateReport(stream, queryable, request);
    }

    private void ValidateRequest(AdminReportRequest request)
    {
        if (request.Period == ReportPeriod.Custom)
        {
            if (!request.From.HasValue || !request.To.HasValue)
            {
                throw new BadRequestException("Opseg datuma je obavezan!");
            }
        }
    }

    private async Task<byte[]> GenerateReport(MemoryStream stream, IQueryable<BaseReportDto> queryable, AdminReportRequest request)
    {
        var data = await queryable.ToListAsync();
        Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(2, Unit.Centimetre);
                    page.PageColor(Colors.White);
                    page.DefaultTextStyle(x => x.FontSize(12));

                    page.Header()
                        .Text(GetHeader(request))
                        .SemiBold().FontSize(24).FontColor(Colors.Blue.Medium);

                    page.Content()
                        .PaddingVertical(1, Unit.Centimetre)
                        .Table(table => CreateTable(table, data));

                    page.Footer()
                        .AlignCenter()
                        .Text(x =>
                        {
                            x.Span("Stranica ");
                            x.CurrentPageNumber();
                        });
                });
            })
            .GeneratePdf(stream);

        var fileBytes = stream.ToArray();

        return fileBytes;
    }

    private IQueryable<BaseReportDto> GetQuerySet(AdminReportRequest request)
    {
        var queryable = GetBaseQuerySet(request.Type);
        queryable = GetQuerySetBasedOnDate(queryable, request);
        return queryable;
    }

    private IQueryable<BaseReportDto> GetBaseQuerySet(ReportType type) {
        switch (type)
        {
            case ReportType.RegisteredUsers:
                return _dbContext.Users.Select(u => new RegisteredUsersReportDto()
                {
                    Status = u.Status,
                    CreatedAt = u.RegisteredAt
                }).OrderByDescending(it => it.CreatedAt).AsQueryable();
            case ReportType.Fares:
                return _dbContext.Fares.Select(f => new AllFaresReportDto()
                {
                    Status = f.Status,
                    CreatedAt = f.CreatedAt
                }).OrderByDescending(it => it.CreatedAt).AsQueryable();
            default:
                throw new Exception("Invalid report type!");
        }
    }

    private IQueryable<BaseReportDto> GetQuerySetBasedOnDate(IQueryable<BaseReportDto> queryable, AdminReportRequest request)
    {
        var now = DateTime.UtcNow;
        switch (request.Period) {
            case ReportPeriod.Mtd:
                return queryable.Where(it => it.CreatedAt.Month == now.Month && it.CreatedAt.Year == now.Year);
            case ReportPeriod.Wtd:
                int daysSinceMonday = now.DayOfWeek - DayOfWeek.Monday;

                if (daysSinceMonday < 0)
                    daysSinceMonday += 7;

                DateTime weekToDateStart = now.AddDays(-daysSinceMonday);
                return queryable.Where(it => it.CreatedAt >= weekToDateStart);
            case ReportPeriod.Ytd:
                return queryable.Where(it => it.CreatedAt.Year == now.Year);
            case ReportPeriod.Custom:
                return queryable.Where(it => it.CreatedAt >= request.From!.Value && it.CreatedAt <= request.To!.Value);
            default:
                throw new Exception("Invalid report period!");
        }
    }

    private string GetHeader(AdminReportRequest request)
    {
        var header = string.Empty;
        switch (request.Type)
        {
            case ReportType.RegisteredUsers: 
                header += "Izvještaj registrovanih korisnika";
                break;
            case ReportType.Fares:
                header += "Izvještaj o vožnjama";
                break;
            default:
                throw new Exception("Invalid report type!");
        }

        switch (request.Period)
        {
            case ReportPeriod.Mtd:
                header += " - ovaj mjesec";
                break;
            case ReportPeriod.Wtd:
                header += " - ova sedmica";
                break;
            case ReportPeriod.Ytd:
                header += " - ova godina";
                break;
            case ReportPeriod.Custom:
                header += $" - ({request.From!.Value.ToString("dd.MM.yyyy.")} - {request.To!.Value.ToString("dd.MM.yyyy.")})";
                break;
            default:
                throw new Exception("Invalid report type!");
        }
        return header;
    }

    private void CreateTable(TableDescriptor descriptor, List<BaseReportDto> data)
    {
        if (!data.Any()) {
            descriptor.ColumnsDefinition(c => c.RelativeColumn());
            descriptor.Cell().Text("Nema podataka za prikaz.");
            return;
        }

        if (data.FirstOrDefault() is RegisteredUsersReportDto) {
            var registeredUsers = data.Cast<RegisteredUsersReportDto>().ToList();

            descriptor.ColumnsDefinition(columns =>
            {
                columns.RelativeColumn();
                columns.ConstantColumn(100);
            });


            descriptor.Cell().Text("Status").Bold();
            descriptor.Cell().Text("Datum registracije").Bold();

            foreach (var user in registeredUsers) {
                if (user.Status == AccountStatus.WaitingForReview)
                {
                    descriptor.Cell().Text(StatusHelper.AccountStatusDictionary[user.Status]).Bold();
                }
                else
                {
                    descriptor.Cell().Text(StatusHelper.AccountStatusDictionary[user.Status]);

                }
                descriptor.Cell().Text(user.CreatedAt.ToString("dd.MM.yyyy."));
            }
        }
        else if (data.FirstOrDefault() is AllFaresReportDto) {
            var allFares = data.Cast<AllFaresReportDto>().ToList();

            descriptor.ColumnsDefinition(columns =>
            {
                columns.RelativeColumn();
                columns.ConstantColumn(100);
            });


            descriptor.Cell().Text("Status").Bold();
            descriptor.Cell().Text("Datum").Bold();

            foreach (var fare in allFares) {
                if (fare.Status == FareStatus.Completed) {
                    descriptor.Cell().Text(StatusHelper.FareStatusDictionary[fare.Status]).Bold();
                }
                else {
                    descriptor.Cell().Text(StatusHelper.FareStatusDictionary[fare.Status]);

                }
                descriptor.Cell().Text(fare.CreatedAt.ToString("dd.MM.yyyy."));
            }
        }
    }
}