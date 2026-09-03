using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.UserProfile;

public class UserProfileService : BaseService<UserProfileResponse, Database.UserProfile, BaseSearchObject>
{
    private readonly AuthorizationService _authorizationService;

    public UserProfileService(MojPrijevozDbContext dbContext, IMapper mapper,
        AuthorizationService authorizationService) : base(dbContext, mapper)
    {
        _authorizationService = authorizationService;
    }

    public override async Task<UserProfileResponse> GetByIdAsync(int id)
    {
        var response = await base.GetByIdAsync(id);
        var currentUserId = _authorizationService.GetUserId();
        if (response.UserId != currentUserId)
            response.User.RedactPrivateFields();

        return response;
    }

    protected override async Task PrepareForResponse(Database.UserProfile entity, MojPrijevozDbContext dbContext)
    {
        await base.PrepareForResponse(entity, dbContext);
        entity.User = await dbContext.Users.FindAsync(entity.UserId);
        entity.RatingTos = await dbContext.Ratings.Include(it => it.From)
            .ThenInclude(it => it!.User)
            .Where(it => it.ToId == entity.Id && it.IsVisible).ToListAsync();
    }
}