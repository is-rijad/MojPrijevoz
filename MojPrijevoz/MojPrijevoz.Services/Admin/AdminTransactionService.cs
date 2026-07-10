using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Admin.Transaction;
using MojPrijevoz.Model.Responses.Admin.Transaction;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Admin;

public class AdminTransactionService : BaseAdminCrudService<Database.Transaction, AdminTransactionUpdateRequest, AdminTransactionUpdateRequest, BaseRequestChanges, AdminTransactionResponse, AdminAllTransactionsResponse, AdminTransactionSearchObject> {
    private readonly INotificationService _notificationService;

    public AdminTransactionService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        INotificationService notificationService) : base(context, mapper, authorizationService) {
        _notificationService = notificationService;

    }

    public override async Task<IQueryable<Transaction>> ApplyFilter(IQueryable<Database.Transaction> queryable, AdminTransactionSearchObject searchObject) {
        queryable = await base.ApplyFilter(queryable, searchObject);
       
        return queryable;
    }

    protected override Transaction MapToUpdateEntity(AdminTransactionUpdateRequest request, Transaction entity)
    {
        base.MapToUpdateEntity(request, entity);
        entity.PostedAt = DateTime.UtcNow;
        return entity;
    }

    public override async Task<IQueryable<Transaction>> IncludeAdditionalEntities(IQueryable<Transaction> queryable)
    {
        await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.Fare).ThenInclude(it => it!.FareData).ThenInclude(it => it!.OriginCity);
        return queryable;
    }

    protected override async Task PrepareForResponse(Transaction entity, MojPrijevozDbContext dbContext)
    {
        await base.PrepareForResponse(entity, dbContext);
        entity.Fare = await _dbContext.Fares.Where(it => it.Id == entity.FareId).Include(it => it.FareData)
            .ThenInclude(it => it!.OriginCity).FirstAsync();
    }

    protected override async Task AfterUpdate(Transaction entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        await _dbContext.Transactions.AddAsync(new Transaction()
        {
            Side = TransactionSide.Credit,
            FareId = entity.FareId,
            Amount = entity.Amount,
            PostedAt = entity.PostedAt
        });
        var fare = await _dbContext.Fares.Include(it => it.FareData).ThenInclude(it => it!.OriginCity)
            .Include(it => it.Driver).ThenInclude(it => it!.User).Include(it => it.Passenger)
            .ThenInclude(it => it!.User).FirstAsync(it => it.Id == entity.FareId);
        var userVehicle = await _dbContext.UserVehicles.Include(it => it.Vehicle)
            .FirstAsync(it => it.Id == fare.UserVehicleId);
        await _notificationService.SendEmailAsync(new EmailDto()
        {
            To = fare.Driver!.User!.Email,
            Type = EmailType.TransactionPostedEmail,
            Data = new Dictionary<string, dynamic>()
            {
                ["Name"] = fare.Driver!.User!.FirstName,
                ["PostedAt"] = entity.PostedAt!.Value.ToLocalTime().ToString("dd/MM/yyyy HH:mm"),
                ["FareDateTime"] = fare.FareData!.FareDateTime.ToLocalTime().ToString("dd/MM/yyyy HH:mm"),
                ["FareData"] = $"{fare!.FareData!.OriginCity!.Name}-{fare!.FareData!.DestinationName}",
                ["Price"] = Math.Round(entity.Amount, 2),
                ["Vehicle"] = userVehicle!.Vehicle!.ToString()
            }
        });
    }

    public override Task BeforeRequestChanges(int id) {
        throw new NotImplementedException();
    }

    public override Task SetEntityStatusToWaitingForChanges(int id) {
        throw new NotImplementedException();
    }

    public override BaseRequestChanges MapIdToRequestChanges(int id, BaseRequestChanges entity) {
        throw new NotImplementedException();
    }

    public override Task SendNotificationEmail(List<BaseRequestChanges> entities) {
        throw new NotImplementedException();
    }
}