using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Admin.Transaction;
using MojPrijevoz.Model.Responses.Admin.Transaction;
using MojPrijevoz.Model.Responses.Admin.User;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.Helpers;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminTransactionService : BaseAdminCrudService<Transaction, AdminTransactionUpdateRequest,
    AdminTransactionUpdateRequest, BaseRequestChanges, AdminTransactionResponse, AdminAllTransactionsResponse,
    AdminTransactionSearchObject>
{
    private readonly INotificationService _notificationService;
    private readonly AdminUsersService _usersService;

    public AdminTransactionService(MojPrijevozDbContext context, IMapper mapper,
        AuthorizationService authorizationService,
        INotificationService notificationService,
        AdminUsersService usersService) : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
        _usersService = usersService;
    }

    public override async Task<IQueryable<Transaction>> ApplyFilter(IQueryable<Transaction> queryable,
        AdminTransactionSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        queryable = queryable.Where(it =>
            it.Fare!.Status == FareStatus.Completed && (searchObject.UserId == -1 || it.Fare.Driver!.UserId == searchObject.UserId) &&
            it.CreatedAt.Month == searchObject.Month + 1);
        queryable = searchObject.IsPosted ? queryable.Where(it => it.PostedAt != null) : queryable.Where(it => it.PostedAt == null);
        return queryable;
    }

    public override Task<AdminTransactionResponse> UpdateAsync(int id, AdminTransactionUpdateRequest request)
    {
        throw new MethodAccessException("Method is not used!");
    }

    public async Task<AdminTransactionResponse> UpdateTransactionsAsync(AdminTransactionSearchObject searchObject)
    {
        if (searchObject.UserId == -1)
            throw new BadRequestException("UserId je obavezan!");
        if (searchObject.IsPosted)
            throw new BadRequestException("Nije moguće proknjižiti proknjižene transakcije!");

        var transactions = await _dbContext.Transactions.Where(it =>
            it.Fare!.Driver!.UserId == searchObject.UserId && it.CreatedAt.Month == searchObject.Month + 1).ToListAsync();

        if (transactions.Count == 0)
            throw new NotFoundException("Nema transakcija za proknjižiti!");

        double price = 0;
        foreach (var transaction in transactions)
        {
            transaction.PostedAt = DateTime.UtcNow;
            price += transaction.Amount;
            await _dbContext.Transactions.AddAsync(new Transaction
            {
                Side = TransactionSide.Credit,
                FareId = transaction.FareId,
                Amount = transaction.Amount - (transaction.FeeAmount ?? 0.0f),
                FeeAmount = null,
                PostedAt = transaction.PostedAt
            });
        }
        var driver = await _dbContext.Users.FirstAsync(it => it.Id == searchObject.UserId);
        await _notificationService.SendEmailAsync(new EmailDto
        {
            To = driver.Email,
            Type = EmailType.TransactionPostedEmail,
            Data = new Dictionary<string, dynamic>
            {
                ["Name"] = driver.FirstName,
                ["Price"] = Math.Round(price, 2),
                ["PostedAt"] = DateTime.Now.ToString("dd/MM/yyyy HH:mm"),
                ["Month"] = MonthHelper.GetMonth(searchObject.Month)
            }
        });
        await _dbContext.SaveChangesAsync();
        return MapToResponseModel<AdminTransactionResponse>(transactions.First(), _mapper);
    }

    public override async Task<IQueryable<Transaction>> IncludeAdditionalEntities(IQueryable<Transaction> queryable)
    {
        await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.Fare).ThenInclude(it => it!.FareData).ThenInclude(it => it!.OriginCity)
            .Include(it => it.Fare).ThenInclude(it => it!.Passenger).ThenInclude(it => it!.User);
        return queryable;
    }

    public async Task<PagedResult<AdminAllUsersResponse>> GetUsersAsync(AdminUserSearchObject searchObject)
    {
        searchObject.OnlyWithBankAccountNumber = true;
        return await _usersService.GetAsync(searchObject);
    }


    public override Task BeforeRequestChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id)
    {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity)
    {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities)
    {
        throw new NotImplementedException();
    }
}