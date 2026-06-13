using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.StopPoint;
using MojPrijevoz.Model.Responses.StopPoint;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.StopPoint;

public class StopPointService : BaseCrudService<Database.StopPoint, StopPointInsertRequest, StopPointInsertRequest, StopPointResponse, StopPointSearchObject>, IStopPointService {
    public StopPointService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService) : base(context, mapper, authorizationService) {
    }

    protected override async Task BeforeInsert(StopPointInsertRequest request) {
        var query = _dbContext.StopPoints.Where(it => it.FareDataId == request.FareDataId &&
                                                      it.Lat == request.Lat && it.Long == request.Long);
        if (await query.AnyAsync()) {
            throw new BadRequestException("Već postoji zaustavno mjesto sa istim koordinatama za ovu vožnju!");

        }
    }
}