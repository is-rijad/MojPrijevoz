using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare.StateMachine;
using MojPrijevoz.Services.NotificationService;

namespace MojPrijevoz.Services.Fare;

public class FareService : BaseCrudService<Database.Fare, FareInsertRequest, FareInsertRequest, FareResponse, FareSearchObject>, IFareService {
    private readonly BaseFareState _baseFareState;
    private readonly INotificationService _notificationService;

    public FareService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, BaseFareState baseFareState, INotificationService notificationService) : base(context, mapper, authorizationService) {
        _baseFareState = baseFareState;
        _notificationService = notificationService;
    }
    public async Task<bool> HasActiveFareForRoute(int passengerId, HasActiveFareRequest request) {
        var queryable = _dbContext.Fares.Where(it =>
            it.FareData!.FareDateTime.Date == request.FareDateTime.Date
        );
        queryable = queryable.Where(it => it.FareData!.OriginCityId == request.OriginCityId);
        queryable = queryable.Where(it => it.FareData!.DestinationLat == request.DestinationCity.Lat &&
                                          it.FareData!.DestinationLong == request.DestinationCity.Long);
        queryable = queryable.Where(it => it.PassengerId == passengerId);


        return await queryable.AnyAsync();
    }

    protected override async Task<IQueryable<Database.Fare>> ApplyOrdering(IQueryable<Database.Fare> queryable, FareSearchObject searchObject) {
        await base.ApplyOrdering(queryable, searchObject);
        queryable = queryable.OrderByDescending(it => it.UpdatedAt).ThenByDescending(it => it.CreatedAt);
        return queryable.AsQueryable();
    }

    public override async Task<FareResponse> InsertAsync(FareInsertRequest request) {
        await BeforeInsert(request);
        var entityEntry = await _dbContext.Fares.AddAsync(MapToInsertEntity(request));
        _baseFareState.GetState(null).Create(entityEntry.Entity);
        await _dbContext.SaveChangesAsync();
        await AfterInsert(entityEntry.Entity, request, _dbContext);
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

    public async Task<FareResponse> RejectAsync(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Reject(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> CancelAsync(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Cancel(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> CompleteAsync(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Complete(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    private async Task IncrementCompletedFares(Database.Fare fare)
    {
        fare.Driver!.NumberOfFares++;
        fare.Passenger!.NumberOfFares++;
        await _dbContext.SaveChangesAsync();
    }

    public async Task<FareResponse> StartAsync(int id) {
        var entity = await _dbContext.Fares.Include(it => it.Passenger).FirstAsync(it => it.Id == id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Start(entity);

        await _dbContext.SaveChangesAsync();

        await _notificationService.SendToUserAsync(new SendToUserDto()
        {
            UserId = entity.Passenger!.UserId,
            Title = "Vozač je pokrenuo vožnju",
            Body = $"Vozač je krenuo prema Vašoj lokaciji",
            Data = new Dictionary<string, string>()
            {
                ["FareId"] = entity.Id.ToString(),
                ["Type"] = SendToUserDto.StartedFareType,
                ["Side"] = ProfileType.Driver.ToString()

            }
        });

        await PrepareForResponse(entity, _dbContext);
        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> PayAsync(int id) {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Pay(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task<FareResponse> ExpireAsync(int id)
    {
        var entity = await _dbContext.Fares.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Vožnja nije pronađena!");
        }
        var state = _baseFareState.GetState((short)entity.Status);
        state.Expire(entity);
        await _dbContext.SaveChangesAsync();

        return MapToResponseModel<FareResponse>(entity, _mapper);
    }

    public async Task MarkAsCompleted()
    {
        var faresToComplete = await _dbContext.Fares
            .Where(it =>
                it.Status == FareStatus.InProgress && it.FareData!.FareDateTime.AddMinutes(it.FareData!.Duration + 60) <
                DateTime.UtcNow)
            .Include(it => it.Driver)
            .ThenInclude(it => it!.User)
            .Include(it => it.Passenger)
            .ThenInclude(it => it!.User).ToListAsync();
        foreach (var fare in faresToComplete)
        {
            await using  var transaction = await _dbContext.Database.BeginTransactionAsync();
            await CompleteAsync(fare.Id);
            await IncrementCompletedFares(fare);
            await SendCompletedNotificationAsync(fare);
            await transaction.CommitAsync();
        }
    }

    private async Task SendCompletedNotificationAsync(Database.Fare fare)
    {
        await _notificationService.SendToUserAsync(new SendToUserDto()
        {
            UserId = fare.Driver!.UserId,
            Title = "Ostavite ocjenu",
            Body = $"Ostavite ocjenu korisniku {fare.Passenger!.User!.FirstName}",
            Data = new Dictionary<string, string>()
            {
                ["FareId"] = fare.Id.ToString(),
                ["Type"] = SendToUserDto.CompletedFareType,
                ["Side"] = ProfileType.Passenger.ToString()

            }
        });
        await _notificationService.SendToUserAsync(new SendToUserDto()
        {
            UserId = fare.Passenger!.UserId,
            Title = "Ostavite ocjenu",
            Body = $"Ostavite ocjenu korisniku {fare.Driver!.User!.FirstName}",
            Data = new Dictionary<string, string>()
            {
                ["FareId"] = fare.Id.ToString(),
                ["Type"] = SendToUserDto.CompletedFareType,
                ["Side"] = ProfileType.Driver.ToString()

            }
        });
    }

    public async Task<PagedResult<FareResponse>> GetNextAcceptedFaresAsync(FareSearchObject searchObject) {
        var userId = _authorizationService.GetUserId();
        var queryable = _dbContext.Fares.Where(it => (it.Passenger!.UserId == userId || it.Driver!.UserId == userId) && (((it.Status == FareStatus.Accepted || it.Status == FareStatus.Payed) && it.FareData!.FareDateTime >= DateTime.UtcNow)) || it.Status == FareStatus.InProgress);
        queryable = await ApplyOrdering(queryable, searchObject);
        var paginatedQueryable = await Paginate(queryable, searchObject);
        queryable = paginatedQueryable.Queryable;
        queryable = queryable.OrderBy(it => it.FareData!.FareDateTime);
        queryable = await IncludeAdditionalEntities(queryable);
        var list = await queryable.Select(e => MapToResponseModel<FareResponse>(e, _mapper)).ToListAsync();
        return new PagedResult<FareResponse>
        {
            Items = list,
            Count = paginatedQueryable.PaginatedCount,
            HasMore = paginatedQueryable.FullCount > searchObject.Page * searchObject.PageSize
        };
    }


    public override async Task<IQueryable<Database.Fare>> ApplyFilter(IQueryable<Database.Fare> queryable, FareSearchObject searchObject) {
        queryable = await base.ApplyFilter(queryable, searchObject);
        var profileId = await _authorizationService.GetProfileId(searchObject.FareRole);

        if (profileId == null)
            throw new BadRequestException("Profil nije pronađen!");

        if (searchObject.FareRole == ProfileType.Driver) {
            queryable = queryable.Where(it => it.DriverId == profileId);
        }
        else if (searchObject.FareRole == ProfileType.Passenger) {
            queryable = queryable.Where(it => it.PassengerId == profileId);
        }

        if (searchObject.FareId != null) {
            queryable = queryable.Where(it => it.Id == searchObject.FareId);
        }
        return queryable;
    }


    public override async Task<IQueryable<Database.Fare>> IncludeAdditionalEntities(IQueryable<Database.Fare> queryable) {
        queryable = await base.IncludeAdditionalEntities(queryable);
        queryable = queryable.Include(it => it.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.UserVehicle)
            .ThenInclude(uv => uv!.Vehicle)
            .Include(it => it.Driver)
            .ThenInclude(it => it!.User)
            .Include(it => it.Driver)
            .Include(it => it.Passenger)
            .ThenInclude(it => it!.User)
            .Include(it => it.Passenger)
            .Include(it => it.FareOffers!.OrderBy(fo => fo.CreatedAt))
            .Include(it => it.FareData)
            .ThenInclude(it => it!.StopPoints);
        return queryable;
    }

    protected override async Task PrepareForResponse(Database.Fare entity, MojPrijevozDbContext dbContext) {
        entity.FareData = await _dbContext.FareData.FindAsync(entity.FareDataId);
        entity.FareData!.StopPoints = await _dbContext.StopPoints.Where(it => it.FareDataId == entity.FareDataId).ToListAsync();
        entity.FareData.OriginCity = await _dbContext.Cities.FindAsync(entity.FareData.OriginCityId);
        entity.Driver = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.DriverId);
        entity.Passenger = await _dbContext.UserProfiles.Include(it => it.User).FirstAsync(it => it.Id == entity.PassengerId);
        entity.FareOffers = await _dbContext.FareOffers.Where(it => it.FareId == entity.Id).OrderBy(fo => fo.CreatedAt).ToListAsync();
        entity.UserVehicle = await _dbContext.UserVehicles.Include(it => it.Vehicle).FirstOrDefaultAsync(it => it.Id == entity.UserVehicleId);
    }

    public async Task<List<string>> AllowedActions(int id) {
        return await _baseFareState.AllowedActions(id);
    }
}