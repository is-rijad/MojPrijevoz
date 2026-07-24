using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Requests.FareData;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Requests.StopPoint;
using MojPrijevoz.Model.Requests.Stripe;
using MojPrijevoz.Model.Requests.Transaction;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.Responses.Stripe;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.FareData;
using MojPrijevoz.Services.FareOffer.StateMachine;
using MojPrijevoz.Services.NotificationService;
using MojPrijevoz.Services.Recommender;
using MojPrijevoz.Services.StopPoint;
using MojPrijevoz.Services.Transactions;

namespace MojPrijevoz.Services.FareOffer;

public class FareOfferService :
    BaseCrudService<Database.FareOffer, FareOfferInsertRequest, FareOfferUpdateRequest, FareResponse,
        FareOfferSearchObject>, IFareOfferService
{
    private readonly BaseFareOfferState _baseFareOfferState;
    private readonly IFareDataService _fareDataService;
    private readonly IFareService _fareService;
    private readonly INotificationService _notificationService;
    private readonly IPaymentService<StripeHandleRequest, StripeHandleResponse> _paymentService;
    private readonly IStopPointService _stopPointService;
    private readonly ITransactionService _transactionService;

    public FareOfferService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        IFareService fareService, IFareDataService fareDataService, IStopPointService stopPointService,
        BaseFareOfferState baseFareOfferState,
        INotificationService notificationService,
        ITransactionService transactionService,
        IPaymentService<StripeHandleRequest, StripeHandleResponse> paymentService) : base(context, mapper,
        authorizationService)
    {
        _fareService = fareService;
        _fareDataService = fareDataService;
        _stopPointService = stopPointService;
        _baseFareOfferState = baseFareOfferState;
        _notificationService = notificationService;
        _transactionService = transactionService;
        _paymentService = paymentService;
    }

    public override async Task<FareResponse> InsertWithTransactionAsync(FareOfferInsertRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var passengerId = (await _authorizationService.GetProfileId(ProfileType.Passenger))!.Value;
        await BeforeInsert(request);

        var fareDataRequest = _mapper.Map<FareDataInsertRequest>(request);
        fareDataRequest.DestinationLat = request.DestinationCity.Lat;
        fareDataRequest.DestinationLong = request.DestinationCity.Long;
        fareDataRequest.DestinationZone =
            ZoneHelper.ToZoneKey(request.DestinationCity.Lat, request.DestinationCity.Long);
        var fareData = await _fareDataService.InsertAsync(fareDataRequest);

        for (var i = 0; i < request.StopPoints.Count; i++)
        {
            var stopPointRequest = _mapper.Map<StopPointInsertRequest>(request.StopPoints[i]);
            stopPointRequest.FareDataId = fareData.Id;
            stopPointRequest.Order = (short)i;
            await _stopPointService.InsertAsync(stopPointRequest);
        }

        var drivers = await _dbContext.UserProfiles
            .Where(up => request.DriversPrices.Select(it => it.DriverId).Contains(up.Id)).Include(it => it.User)
            .ToListAsync();
        var passenger = await _dbContext.UserProfiles.Where(up => up.Id == passengerId).Include(it => it.User)
            .FirstAsync();
        var startLocation = await _dbContext.Cities.Where(c => c.Id == request.OriginCityId).FirstAsync();

        FareResponse? firstFare = null;
        foreach (var driversPrice in request.DriversPrices)
        {
            var fareRequest = MapToFareInsertRequest(passengerId, fareData.Id, driversPrice, request);
            var fare = await _fareService.InsertAsync(fareRequest);
            firstFare ??= fare;

            request.Price = driversPrice.Price;
            request.AdditionalPrice = driversPrice.AdditionalPrice;
            request.UserVehicleId = driversPrice.UserVehicleId;
            request.FareDataId = fareData.Id;
            request.FareId = fare.Id;

            var fareOffer = await _dbContext.FareOffers.AddAsync(MapToInsertEntity(request));
            var baseStateMachine = _baseFareOfferState.GetState(null);
            baseStateMachine.Create(fareOffer.Entity);


            await _notificationService.SendToUserAsync(new SendToUserDto
            {
                UserId = drivers.First(it => it.Id == driversPrice.DriverId).UserId,
                Title = "Nova ponuda vožnje",
                Body = $"Korisnik {passenger.User!.FirstName} je poslao ponudu za vožnju",
                Data = new Dictionary<string, string>
                {
                    ["FareId"] = fare.Id.ToString(),
                    ["Type"] = SendToUserDto.NewFareOfferType,
                    ["Side"] = ProfileType.Passenger.ToString()
                }
            });
        }

        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();


        await _notificationService.SendEmailAsync(new EmailDto
        {
            To = passenger.User!.Email,
            Type = EmailType.SentFareOfferEmail,
            Data = new Dictionary<string, dynamic>
            {
                ["ReceipantName"] = passenger.User!.FirstName,
                ["FareDateTime"] = DateTime.Now.ToString("dd/MM/yyyy HH:mm"),
                ["StartLocation"] = startLocation.Name,
                ["EndLocation"] = request.DestinationName,
                ["Drivers"] = drivers.Select(it => new
                {
                    it.User!.FirstName, it.User!.LastName
                }).ToList()
            }
        });

        return await _fareService.GetByIdAsync(firstFare!.Id);
    }

    public override async Task<FareResponse> UpdateWithTransactionAsync(int id, FareOfferUpdateRequest request)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it!.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Driver)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Passenger)
            .FirstAsync(it => it.Id == id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");

        await CheckIsOfferOwner(entity);

        await _authorizationService.CheckIsAccountActive(entity.Fare!.DriverId);

        await BeforeUpdate(id, request, entity);

        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Expire(entity);
        var newEntity = MapToUpdateEntity(request, entity);
        await _dbContext.FareOffers.AddAsync(newEntity);
        state = _baseFareOfferState.GetState((short)FareOfferStatus.WaitingForResponse);
        state.Update(id, newEntity);
        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        await SendUpdateNotification(newEntity, entity);
        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    private async Task CheckIsOfferOwner(Database.FareOffer entity)
    {
        var passengerProfileId = await _authorizationService.GetProfileId(ProfileType.Passenger);
        var driverProfileId = await _authorizationService.GetProfileId(ProfileType.Driver);
        if (driverProfileId != entity.Fare!.DriverId || passengerProfileId != entity.Fare!.PassengerId) {
            throw new ForbiddenException("Nije vaša ponuda!");
        }
    }

    public async Task<FareResponse> AcceptOfferAsync(int id)
    {
        await _authorizationService.CheckIsAccountActive();
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();


        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Driver)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Passenger)
            .FirstAsync(it => it.Id == id);
        if (entity == null) throw new NotFoundException("Ponuda nije pronađena!");
        await CheckIsOfferOwner(entity);

        await _authorizationService.CheckIsAccountActive(entity.Fare!.DriverId);

        var newStart = entity.Fare!.FareData!.FareDateTime;
        var newEnd = entity.Fare!.FareData!.FareDateTime.AddMinutes(entity.Fare!.FareData!.Duration);

        var unavailableQuery = _dbContext.Fares
            .Where(f =>
                (f.Status == FareStatus.Accepted || f.Status == FareStatus.Payed ||
                 f.Status == FareStatus.InProgress) &&
                (f.FareStartAfter ?? f.FareData!.FareDateTime.AddMinutes(-30)) < newEnd &&
                f.FareData!.FareDateTime.AddMinutes(f.FareData.Duration) > newStart).AsQueryable();
        var isDriverUnavailable = await unavailableQuery
            .Where(f => f.DriverId == entity.Fare!.DriverId
            ).AnyAsync();
        if (isDriverUnavailable)
        {
            var tempState = _baseFareOfferState.GetState((short)entity.Status);
            tempState.Expire(entity);
            await _fareService.ExpireAsync(entity!.Fare!.Id);
            await _dbContext.SaveChangesAsync();
            await transaction.CommitAsync();
            throw new BadRequestException("Vozač je zauzet u tom periodu!");
        }

        var isPassengerUnavailable = await unavailableQuery
            .Where(f => f.PassengerId == entity.Fare!.PassengerId
            ).AnyAsync();
        if (isPassengerUnavailable)
        {
            var tempState = _baseFareOfferState.GetState((short)entity.Status);
            tempState.Expire(entity);
            await _fareService.ExpireAsync(entity!.Fare!.Id);
            await _dbContext.SaveChangesAsync();
            await transaction.CommitAsync();
            throw new BadRequestException("Putnik je zauzet u tom periodu!");
        }

        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Accept(entity);
        await _fareService.AcceptAsync(entity!.Fare!.Id);
        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();

        await SendUpdateNotification(entity, null);

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    public async Task<FareResponse> RejectOfferAsync(int id)
    {
        await _authorizationService.CheckIsAccountActive();

        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Driver)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Passenger)
            .FirstAsync(it => it.Id == id);
        if (entity == null) throw new NotFoundException("Ponuda nije pronađena!");

        await CheckIsOfferOwner(entity);
        await _authorizationService.CheckIsAccountActive(entity.Fare!.DriverId);

        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Reject(entity);
        await _fareService.RejectAsync(entity!.Fare!.Id);
        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();

        await SendUpdateNotification(entity, null);


        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    public async Task<FareResponse> ExpireOfferAsync(int id)
    {
        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .FirstAsync(it => it.Id == id);

        if (entity == null) throw new NotFoundException("Ponuda nije pronađena!");
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Expire(entity);
        await _fareService.ExpireAsync(entity!.Fare!.Id);
        var transaction = await _dbContext.Transactions.FirstOrDefaultAsync(it => it.FareId == entity.FareId);
        if (transaction?.PaymentIntentId != null)
            await _paymentService.CreateRefund(entity.Id, transaction.PaymentIntentId);
        await _dbContext.SaveChangesAsync();

        await SendUpdateNotification(entity, null);

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    public override async Task<FareResponse> UpdateAsync(int id, FareOfferUpdateRequest request)
    {
        await _authorizationService.CheckIsAccountActive();

        var updated = await base.UpdateAsync(id, request);
        return await _fareService.GetByIdAsync(updated.Id);
    }

    public async Task<FareResponse> CancelOfferAsync(int id)
    {
        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(fareOffer => fareOffer.Fare!)
            .ThenInclude(fare => fare.Driver!)
            .Include(fareOffer => fareOffer.Fare)
            .ThenInclude(fare => fare!.Passenger!)
            .FirstAsync(it => it.Id == id);
        if (entity == null) throw new NotFoundException("Ponuda nije pronađena!");

        await CheckIsOfferOwner(entity);

        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Cancel(entity);
        await _fareService.CancelAsync(entity!.Fare!.Id);
        var transaction = await _dbContext.Transactions.FirstOrDefaultAsync(it => it.FareId == entity.FareId);
        if (transaction?.PaymentIntentId != null)
            await _paymentService.CreateRefund(entity.Id, transaction.PaymentIntentId);
        await _dbContext.SaveChangesAsync();

        var userId = _authorizationService.GetUserId();
        var side = ProfileType.Passenger;
        if (entity.Fare!.Driver!.UserId == userId)
            side = ProfileType.Driver;

        await _notificationService.SendToUserAsync(new SendToUserDto
        {
            UserId = side == ProfileType.Passenger ? entity.Fare.Driver.UserId : entity.Fare.Passenger!.UserId,
            Title = "Ponuda otkazana",
            Body =
                $"Ponuda u iznosu od {Math.Round(entity.TotalPrice, 2)}KM ({entity.Fare!.FareData!.OriginCity!.Name} - {entity.Fare!.FareData!.DestinationName.Split(",").First()}) je otkazana",
            Data = new Dictionary<string, string>
            {
                ["FareId"] = entity.FareId.ToString(),
                ["Type"] = SendToUserDto.CancelledFareOfferType,
                ["Side"] = side.ToString()
            }
        });

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }


    public async Task<FareResponse> PayOfferAsync(int id, string paymentIntentId)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .ThenInclude(it => it!.FareData)
            .ThenInclude(it => it!.OriginCity)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Driver)
            .Include(it => it.Fare)
            .ThenInclude(it => it!.Passenger)
            .FirstAsync(it => it.Id == id);
        if (entity == null) throw new NotFoundException("Ponuda nije pronađena!");
        await CheckIsOfferOwner(entity);
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Pay(entity);
        await _fareService.PayAsync(entity!.Fare!.Id);
        await _transactionService.InsertAsync(new TransactionInsertRequest
        {
            Amount = entity.TotalPrice * (1 - 0.10f),
            FeeAmount = entity.TotalPrice * 0.10f,
            FareId = entity.FareId,
            Side = TransactionSide.Debit,
            PaymentIntentId = paymentIntentId
        });

        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();

        await SendUpdateNotification(entity, null);

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    public async Task MarkAsExpired()
    {
        var fareOffersToExpire = await _dbContext.FareOffers
            .Where(it =>
                (it.Status == FareOfferStatus.WaitingForResponse && (it.UpdatedAt.AddHours(48) <=
                    DateTime.UtcNow || it.CreatedAt.AddHours(48) <=
                    DateTime.UtcNow)) || (it.Status == FareOfferStatus.Accepted &&
                                          it.Fare!.FareStartAfter!.Value.AddMinutes(-60) < DateTime.UtcNow))
            .Include(it => it.Fare!.Driver)
            .ThenInclude(it => it!.User)
            .Include(it => it.Fare!.Passenger)
            .ThenInclude(it => it!.User).ToListAsync();
        foreach (var fare in fareOffersToExpire)
        {
            Console.WriteLine($"Exipring => {fare.Id}");
            await ExpireOfferAsync(fare.Id);
        }
    }


    public async Task<List<string>> AllowedActions(int id)
    {
        return await _baseFareOfferState.AllowedActions(id);
    }

    protected override async Task BeforeInsert(FareOfferInsertRequest request)
    {
        await _authorizationService.CheckIsAccountActive();
        if (await _fareService.HasActiveFareForRoute(request.PassengerId, _mapper.Map<HasActiveFareRequest>(request)))
            throw new BadRequestException("Već imate zakazanu vožnju za istu rutu, na isti dan!");
        if (request.FareDateTime < DateTime.UtcNow)
            throw new BadRequestException("Vrijeme vožnje ne može biti u prošlosti!");


        if (request.DriversPrices.Any(it => it.Price + (it.AdditionalPrice ?? 0) < 1))
            throw new BadRequestException("Ukupna cijena ne može biti manja od 1KM!");

        await base.BeforeInsert(request);
    }

    protected override IQueryable<Database.FareOffer> ApplyOrdering(IQueryable<Database.FareOffer> queryable,
        FareOfferSearchObject searchObject)
    {
        queryable = queryable.OrderByDescending(it => it.UpdatedAt).ThenByDescending(it => it.CreatedAt);
        return queryable.AsQueryable();
    }

    protected override async Task BeforeUpdate(int id, FareOfferUpdateRequest request, Database.FareOffer entity)
    {
        await _authorizationService.CheckIsAccountActive();

        await base.BeforeUpdate(id, request, entity);
        if (request.Price + (request.AdditionalPrice ?? 0) < 1)
            throw new BadRequestException("Ukupna cijena ne može biti manja od 1KM!");
    }

    private async Task SendUpdateNotification(Database.FareOffer entity, Database.FareOffer? oldEntity)
    {
        var driver = await _dbContext.UserProfiles.Where(up => up.Id == entity.Fare!.DriverId).Include(it => it.User)
            .FirstAsync();
        var passenger = await _dbContext.UserProfiles.Where(up => up.Id == entity.Fare!.PassengerId)
            .Include(it => it.User).FirstAsync();
        var userVehicle = await _dbContext.UserVehicles.Where(uv => uv.Id == entity.Fare!.UserVehicleId)
            .Include(it => it.Vehicle).FirstAsync();

        switch (entity.Status)
        {
            case FareOfferStatus.Accepted:
                await _notificationService.SendToUserAsync(new SendToUserDto
                {
                    UserId = entity.Side == ProfileType.Passenger ? passenger.UserId : driver.UserId,
                    Title = "Prihvaćena ponuda",
                    Body =
                        $"Korisnik {(entity.Side == ProfileType.Passenger ? driver.User!.FirstName : passenger.User!.FirstName)} je prihvatio Vašu ponudu",
                    Data = new Dictionary<string, string>
                    {
                        ["FareId"] = entity.FareId.ToString(),
                        ["Type"] = SendToUserDto.AcceptedFareOfferType,
                        ["Side"] = entity.Side.ToString()
                    }
                });
                break;
            case FareOfferStatus.WaitingForResponse:
                await _notificationService.SendToUserAsync(new SendToUserDto
                {
                    UserId = entity.Side == ProfileType.Passenger ? driver.UserId : passenger.UserId,
                    Title = "Nova ponuda",
                    Body =
                        $"Korisnik {(entity.Side == ProfileType.Passenger ? passenger.User!.FirstName : driver.User!.FirstName)} je poslao novu ponudu u iznosu od {Math.Round(entity.TotalPrice, 2)}KM",
                    Data = new Dictionary<string, string>
                    {
                        ["FareId"] = entity.FareId.ToString(),
                        ["Type"] = SendToUserDto.NewFareOfferType,
                        ["Side"] = entity.Side.ToString()
                    }
                });
                break;
            case FareOfferStatus.Rejected:
                await _notificationService.SendToUserAsync(new SendToUserDto
                {
                    UserId = entity.Side == ProfileType.Passenger ? passenger.UserId : driver.UserId,
                    Title = "Odbijena ponuda",
                    Body =
                        $"Korisnik {(entity.Side == ProfileType.Passenger ? driver.User!.FirstName : passenger.User!.FirstName)} je odbio ponudu u iznosu od {Math.Round(entity.TotalPrice, 2)}KM",
                    Data = new Dictionary<string, string>
                    {
                        ["FareId"] = entity.FareId.ToString(),
                        ["Type"] = SendToUserDto.RejectedFareOfferType,
                        ["Side"] = (entity.Side == ProfileType.Passenger ? ProfileType.Driver : ProfileType.Passenger)
                            .ToString()
                    }
                });
                break;
            case FareOfferStatus.Payed:
                await _notificationService.SendToUserAsync(new SendToUserDto
                {
                    UserId = driver.UserId,
                    Title = "Ponuda plaćena",
                    Body =
                        $"Ponuda u iznosu od {Math.Round(entity.TotalPrice, 2)}KM ({entity.Fare!.FareData!.OriginCity!.Name} - {entity.Fare!.FareData!.DestinationName.Split(",").First()}) je plaćena",
                    Data = new Dictionary<string, string>
                    {
                        ["FareId"] = entity.FareId.ToString(),
                        ["Type"] = SendToUserDto.PayedFareOfferType,
                        ["Side"] = ProfileType.Passenger.ToString()
                    }
                });
                await _notificationService.SendEmailAsync(new EmailDto
                {
                    To = passenger.User!.Email,
                    Type = EmailType.ReceiptFareOfferEmail,
                    Data = new Dictionary<string, dynamic>
                    {
                        ["ReceipantName"] = passenger.User!.FirstName,
                        ["TransactionDateTime"] = DateTime.Now.ToString("dd/MM/yyyy. HH:mm"),
                        ["StartLocation"] = entity.Fare!.FareData!.OriginCity!.Name,
                        ["EndLocation"] = entity.Fare!.FareData!.DestinationName,
                        ["Price"] = Math.Round(entity.TotalPrice, 2),
                        ["Vehicle"] = userVehicle!.Vehicle!.ToString(),
                        ["FareDateTime"] = entity.Fare!.FareData!.FareDateTime.ToString("dd/MM/yyyy. HH:mm")
                    }
                });
                break;
        }
    }

    protected override Database.FareOffer MapToUpdateEntity(FareOfferUpdateRequest request, Database.FareOffer entity)
    {
        var side = entity.Side == ProfileType.Passenger ? ProfileType.Driver : ProfileType.Passenger;

        return new Database.FareOffer
        {
            FareId = entity.FareId,
            LastOfferId = entity.Id,
            Price = request.Price,
            AdditionalPrice = request.AdditionalPrice,
            Side = side
        };
    }

    private FareInsertRequest MapToFareInsertRequest(int passengerId, int fareDataId,
        FareOfferDriverPriceDto driverPrice, FareOfferInsertRequest fareOfferRequest)
    {
        var fareInsertRequest = _mapper.Map<FareInsertRequest>(fareOfferRequest);

        fareInsertRequest.DriverId = driverPrice.DriverId;
        fareInsertRequest.UserVehicleId = driverPrice.UserVehicleId;
        fareInsertRequest.PassengerId = passengerId;
        fareInsertRequest.FareDataId = fareDataId;

        return fareInsertRequest;
    }

    protected override Database.FareOffer MapToInsertEntity(FareOfferInsertRequest request)
    {
        return new Database.FareOffer
        {
            Side = ProfileType.Passenger,
            FareId = request.FareId,
            Price = request.Price,
            AdditionalPrice = request.AdditionalPrice,
            LastOfferId = request.LastOfferId
        };
    }
}