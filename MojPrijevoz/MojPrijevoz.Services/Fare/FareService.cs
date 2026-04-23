using Azure;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare.StateMachine;

namespace MojPrijevoz.Services.Fare;

public class FareService : BaseCrudService<Database.Fare, FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>, IFareService {
    private readonly BaseFareState _baseFareState;

    public FareService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, BaseFareState baseFareState) : base(context, mapper, authorizationService)
    {
        _baseFareState = baseFareState;
    }
    public async Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request)
    {
        var queryable = _dbContext.Fares.Where(it =>
            it.FareData!.FareDateTime.Date == request.FareDateTime.Date
        );
        queryable = queryable.Where(it => it.FareData!.OriginCityId == request.OriginCityId);
        queryable = queryable.Where(it => it.FareData!.DestinationLat == request.DestinationCity.Lat &&
                                          it.FareData!.DestinationLong == request.DestinationCity.Long);
        queryable = queryable.Where(it => it.PassengerId == passengerId);
        
        
        return await queryable.AnyAsync();
    }

    public override async Task<FareResponse> InsertAsync(FareInsertRequest request)
    {
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Fares.AddAsync(MapToInsertEntity(request));
        _baseFareState.GetState(null).Create(entityEntry.Entity);
        await _dbContext.SaveChangesAsync();
        await AfterInsert(entityEntry.Entity, _dbContext);
        await PrepareForResponse(entityEntry.Entity, _dbContext);
        return MapToResponseModel<FareResponse>(entityEntry.Entity, _mapper);
    }

    public async Task<FareResponse> AcceptAsync(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        await state.Accept(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> RejectAsync(int id)
    {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Reject(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> CancelAsync(int id)
    {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Cancel(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> CompleteAsync(int id)
    {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Complete(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> StartAsync(int id)
    {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Start(entity);

        await _dbContext.SaveChangesAsync();

        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<PagedResult<FareResponse>> GetNextAcceptedFaresAsync(FareSearchObject searchObject)
    {
        var userId = _authorizationService.GetUserId();
        var queryable = _dbContext.Fares.Where(it => (it.Passenger!.UserId == userId || it.Driver!.UserId == userId) && it.Status == FareStatus.Accepted && it.FareData!.FareDateTime > DateTime.UtcNow);
        var fullCount = await queryable.CountAsync();
        queryable = queryable.Skip((searchObject.Page - 1) * searchObject.PageSize).Take(searchObject.PageSize);
        queryable = queryable.OrderBy(it => it.FareData!.FareDateTime);
        queryable = await IncludeAdditionalEntities(queryable);
        var list = await queryable.Select(e => MapToResponseModel<FareResponse>(e, _mapper)).ToListAsync();
        return new PagedResult<FareResponse>
        {
            Items = list,
            Count = queryable.Count(),
            HasMore = fullCount > searchObject.Page * searchObject.PageSize
        };
    }


    public override async Task<IQueryable<Database.Fare>> ApplyFilter(IQueryable<Database.Fare> queryable, FareSearchObject searchObject)
    {
        queryable = await base.ApplyFilter(queryable, searchObject);
        var profileId = await _authorizationService.GetProfileId(searchObject.FareRole);

        if (profileId == null)
            throw new BadRequestException("Profil nije pronađen!");

        if (searchObject.FareRole == ProfileType.Driver)
        {
            queryable = queryable.Where(it => it.DriverId == profileId);
        }
        else if (searchObject.FareRole == ProfileType.Passenger)
        {
            queryable = queryable.Where(it => it.PassengerId == profileId);
        }
        return queryable;
    }


    public override async Task<IQueryable<Database.Fare>> IncludeAdditionalEntities(IQueryable<Database.Fare> queryable)
    {
        queryable = await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.UserVehicle)
            .ThenInclude(uv => uv!.Vehicle)
            .Include(it => it.Driver)
            .ThenInclude(it => it!.User)
            .Include(it => it.Passenger)
            .ThenInclude(it => it!.User)
            .Include(it => it.FareOffers!.OrderBy(fo => fo.CreatedAt))
            .Include(it => it.FareData)
            .ThenInclude(it => it!.StopPoints);
        return queryable;
    }

    protected override async Task PrepareForResponse(Database.Fare entity, MojPrijevozDbContext dbContext)
    {
        entity.FareData = await _dbContext.FareData.FindAsync(entity.FareDataId);
        entity.FareData!.StopPoints = await _dbContext.StopPoints.Where(it => it.FareDataId == entity.FareDataId).ToListAsync();
        entity.FareData.OriginCity = await _dbContext.Cities.FindAsync(entity.FareData.OriginCityId);
        entity.Driver = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.DriverId);
        entity.Passenger = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.PassengerId);
        entity.FareOffers = await _dbContext.FareOffers.Where(it => it.FareId == entity.Id).OrderBy(fo => fo.CreatedAt).ToListAsync();
        entity.UserVehicle = await _dbContext.UserVehicles.Include(it => it.Vehicle).FirstOrDefaultAsync(it => it.Id == entity.UserVehicleId);
    }

    public async Task<List<string>> AllowedActions(int id)
    {
        return await _baseFareState.AllowedActions(id);
    }
}