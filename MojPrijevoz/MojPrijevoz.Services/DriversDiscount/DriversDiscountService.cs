using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.DriversDiscount;
using MojPrijevoz.Model.Responses.DriversDiscount;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.DriversDiscount;

public class DriversDiscountService : BaseCrudService<Database.DriversDiscount, DriversDiscountUpsertRequest, DriversDiscountUpsertRequest, DriversDiscountResponse, DriversDiscountSearchObject> {
    public DriversDiscountService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService) {
    }

    private async Task<bool> AreOverlapping(int profileId, float minKm, float? maxKm, int? id = null) {
        var queryable = _dbContext.DriversDiscounts.Where(dd =>
            dd.ProfileId == profileId && (maxKm == null || dd.MinKm <= maxKm) &&
            (dd.MaxKm == null || minKm <= dd.MaxKm));
        if (id.HasValue)
            queryable = queryable.Where(dd => dd.Id != id.Value);
        return await queryable.AnyAsync();

    }
    public override async Task<IQueryable<Database.DriversDiscount>> ApplyFilter(
        IQueryable<Database.DriversDiscount> queryable, DriversDiscountSearchObject searchObject) {
        var profileId = (await _authorizationService.GetProfileId(ProfileType.Driver));
        if (!profileId.HasValue)
            throw new BadRequestException("Niste vozač");

        return queryable.Where(dd => dd.ProfileId == profileId.Value);
    }
    protected override async Task BeforeInsert(DriversDiscountUpsertRequest request) {
        await base.BeforeInsert(request);
        var profileId = (await _authorizationService.GetProfileId(ProfileType.Driver));
        if (!profileId.HasValue)
            throw new BadRequestException("Niste vozač");
        if (await AreOverlapping(profileId.Value, request.MinKm, request.MaxKm))
            throw new BadRequestException("Popust za tu kilometražu već postoji");
        request.ProfileId = profileId.Value;
    }
    protected override async Task BeforeUpdate(int id, DriversDiscountUpsertRequest request, Database.DriversDiscount entity) {
        await base.BeforeUpdate(id, request, entity);
        var profileId = (await _authorizationService.GetProfileId(ProfileType.Driver));
        if (!profileId.HasValue)
            throw new BadRequestException("Niste vozač");
        if (await AreOverlapping(profileId.Value, request.MinKm, request.MaxKm, entity.Id))
            throw new BadRequestException("Popust za tu kilometražu već postoji");
        if (entity.ProfileId != profileId.Value)
            throw new BadRequestException("Nije vaš popust!");
        request.ProfileId = profileId.Value;
    }

    protected override async Task BeforeDelete(int id, Database.DriversDiscount entity) {
        await base.BeforeDelete(id, entity);
        var profileId = (await _authorizationService.GetProfileId(ProfileType.Driver));
        if (!profileId.HasValue)
            throw new BadRequestException("Niste vozač");
        if (entity.ProfileId != profileId.Value)
            throw new BadRequestException("Nije vaš popust!");
    }
}