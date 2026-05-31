using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.UserProfile;

public class UserProfileService : BaseService<UserProfileResponse, Database.UserProfile, BaseSearchObject>
{
    public UserProfileService(MojPrijevozDbContext dbContext, IMapper mapper) : base(dbContext, mapper)
    {
    }

    protected override async Task PrepareForResponse(Database.UserProfile entity, MojPrijevozDbContext dbContext)
    {
        await base.PrepareForResponse(entity, dbContext);
        entity.User = await dbContext.Users.FindAsync(entity.UserId);
        entity.RatingTos = await dbContext.Ratings.Where(it => it.ToId == entity.Id).ToListAsync();
    }
}