using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Requests.Admin.Rating;
using MojPrijevoz.Model.Responses.Admin.Rating;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices.Admin;
using MojPrijevoz.Services.NotificationService;
using System.Security.Cryptography.X509Certificates;

namespace MojPrijevoz.Services.Admin;

public class AdminRatingService : BaseAdminCrudService<Database.Rating, AdminRatingUpdateRequest, AdminRatingUpdateRequest, BaseRequestChanges, AdminRatingReponse, AdminAllRatingsResponse, AdminRatingSearchObject>
{
    private readonly INotificationService _notificationService;

    public AdminRatingService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        INotificationService notificationService) : base(context, mapper, authorizationService)
    {
        _notificationService = notificationService;
    }

    public override async Task<IQueryable<Database.Rating>> ApplyFilter(IQueryable<Database.Rating> queryable, AdminRatingSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        if (!string.IsNullOrEmpty(searchObject.Contains))
        {
            queryable = queryable.Where(it => it.From!.User!.FirstName.ToLower().Contains(searchObject.Contains.ToLower()) 
                                              || it.To!.User!.FirstName.ToLower().Contains(searchObject.Contains.ToLower())
                                              || it.Grade.ToString().Contains(searchObject.Contains.ToLower())
                                              || (it.IsVisible ? "da" : "ne").Contains(searchObject.Contains.ToLower()));
        }
        return queryable;
    }

    public override async Task<IQueryable<Database.Rating>> IncludeAdditionalEntities(IQueryable<Database.Rating> queryable)
    {
        await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.From).ThenInclude(it => it!.User);
        queryable = queryable.Include(it => it.To).ThenInclude(it => it!.User);
        return queryable;
    }

    protected override async Task PrepareForResponse(Database.Rating entity, MojPrijevozDbContext dbContext)
    {
        await base.PrepareForResponse(entity, dbContext);
        entity.From = await _dbContext.UserProfiles.Include(it => it.User).Where(it => it.Id == entity.FromId).FirstAsync();
        entity.To = await _dbContext.UserProfiles.Include(it => it.User).Where(it => it.Id == entity.ToId).FirstAsync();
        entity.Fare = await _dbContext.Fares.Include(it => it.FareData).ThenInclude(it => it!.OriginCity).Where(it => it.Id == entity.FareId).FirstAsync();
    }

    protected override async Task AfterUpdate(Database.Rating entity, MojPrijevozDbContext dbContext)
    {
        await base.AfterUpdate(entity, dbContext);
        if (entity.IsVisible)
        {
            var fromUser = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.FromId);
            var toUser = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.ToId);
            await _notificationService.SendEmailAsync(new EmailDto()
            {
                To = fromUser.User!.Email,
                Type = EmailType.ReviewVisibleEmail,
                Data = new Dictionary<string, dynamic>()
                {
                    ["Name"] = fromUser.User!.FirstName,
                    ["ToName"] = toUser.User!.FirstName
                }
            });
        }

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