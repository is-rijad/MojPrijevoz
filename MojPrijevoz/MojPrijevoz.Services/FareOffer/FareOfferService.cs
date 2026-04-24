using Azure;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Requests.FareData;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Requests.StopPoint;
using MojPrijevoz.Model.Responses.Fare;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.FareData;
using MojPrijevoz.Services.FareOffer.StateMachine;
using MojPrijevoz.Services.StopPoint;

namespace MojPrijevoz.Services.FareOffer;

public class FareOfferService : BaseCrudService<Database.FareOffer, FareOfferInsertRequest, FareOfferUpdateRequest, FareResponse, FareOfferSearchObject>, IFareOfferService {
    private readonly IFareService _fareService;
    private readonly IFareDataService _fareDataService;
    private readonly IStopPointService _stopPointService;
    private readonly BaseFareOfferState _baseFareOfferState;

    public FareOfferService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        IFareService fareService, IFareDataService fareDataService, IStopPointService stopPointService, BaseFareOfferState baseFareOfferState) : base(context, mapper, authorizationService) {
        _fareService = fareService;
        _fareDataService = fareDataService;
        _stopPointService = stopPointService;
        _baseFareOfferState = baseFareOfferState;
    }

    protected override async Task BeforeInsert(FareOfferInsertRequest request) {
        if (await _fareService.HasActiveFareForRoute(request.PassengerId, _mapper.Map<HasActiveFareRequest>(request))) {
            throw new BadRequestException("Već imate zakazanu vožnju za istu rutu, na isti dan!");
        }

        await base.BeforeInsert(request);
    }

    public override async Task<FareResponse> InsertWithTransactionAsync(FareOfferInsertRequest request) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var passengerId = (await _authorizationService.GetProfileId(ProfileType.Passenger))!.Value;
        await BeforeInsert(request);

        var fareDataRequest = _mapper.Map<FareDataInsertRequest>(request);
        fareDataRequest.DestinationLat = request.DestinationCity.Lat;
        fareDataRequest.DestinationLong = request.DestinationCity.Long;
        var fareData = await _fareDataService.InsertAsync(fareDataRequest);

        for (int i = 0; i < request.StopPoints.Count; i++) {
            var stopPointRequest = _mapper.Map<StopPointInsertRequest>(request.StopPoints[i]);
            stopPointRequest.FareDataId = fareData.Id;
            stopPointRequest.Order = (short)i;
            await _stopPointService.InsertAsync(stopPointRequest);
        }

        EntityEntry<Database.FareOffer>? entityEntry = null;
        foreach (var driversPrice in request.DriversPrices) {
            var fareRequest = MapToFareInsertRequest(passengerId, fareData.Id, driversPrice, request);
            var fare = await _fareService.InsertAsync(fareRequest);
            

            request.Price = driversPrice.Price;
            request.AdditionalPrice = driversPrice.AdditionalPrice;
            request.UserVehicleId = driversPrice.UserVehicleId;
            request.FareDataId = fareData.Id;
            request.FareId = fare.Id;

            entityEntry ??= await _dbContext.FareOffers.AddAsync(MapToInsertEntity(request));
            var baseStateMachine = _baseFareOfferState.GetState(null);
            baseStateMachine.Create(entityEntry.Entity);
        }

        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        return await _fareService.GetByIdAsync(entityEntry!.Entity!.Fare!.Id);
    }

    public override async Task<FareResponse> UpdateAsync(int id, FareOfferUpdateRequest request) {
        var entity = await _dbContext.FareOffers
            .Include(it => it!.Fare)
            .FirstAsync(it => it.Id == id); 
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Expire(entity);
        await BeforeUpdate(id, request, entity);
        var newEntity = MapToUpdateEntity(request, entity);
        await _dbContext.FareOffers.AddAsync(newEntity);
        state = _baseFareOfferState.GetState((short)FareOfferStatus.WaitingForResponse);
        state.Update(id, newEntity);
        await _dbContext.SaveChangesAsync();
        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    protected override Database.FareOffer MapToUpdateEntity(FareOfferUpdateRequest request, Database.FareOffer entity)
    {
        var side = entity.Side == ProfileType.Passenger ? ProfileType.Driver : ProfileType.Passenger;

        return new Database.FareOffer()
        {
            FareId = entity.FareId,
            LastOfferId = entity.Id,
            Price = request.Price,
            AdditionalPrice = request.AdditionalPrice,
            Side = side,
        };
    }

    private FareInsertRequest MapToFareInsertRequest(int passengerId, int fareDataId, FareOfferDriverPriceDto driverPrice, FareOfferInsertRequest fareOfferRequest) {
        var fareInsertRequest = _mapper.Map<FareInsertRequest>(fareOfferRequest);

        fareInsertRequest.DriverId = driverPrice.DriverId;
        fareInsertRequest.UserVehicleId = driverPrice.UserVehicleId;
        fareInsertRequest.PassengerId = passengerId;
        fareInsertRequest.FareDataId = fareDataId;
        
        return fareInsertRequest;
    }

    protected override Database.FareOffer MapToInsertEntity(FareOfferInsertRequest request)
    {
        return new Database.FareOffer()
        {
            Side = ProfileType.Passenger,
            FareId = request.FareId,
            Price = request.Price,
            AdditionalPrice = request.AdditionalPrice,
            LastOfferId = request.LastOfferId
        };
    }

    public async Task<FareResponse> AcceptOfferAsync(int id)
    {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .FirstAsync(it => it.Id == id);
        if (entity == null)
        {
            throw new NotFoundException("Ponuda nije pronađena!");
        }

        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Accept(entity);
        await _fareService.AcceptAsync(entity!.Fare!.Id);
        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);

    }

    public async Task<FareResponse> RejectOfferAsync(int id) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .FirstAsync(it => it.Id == id);
        if (entity == null) {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Reject(entity);
        await _fareService.RejectAsync(entity!.Fare!.Id);
        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }

    public async Task<FareResponse> ExpireOfferAsync(int id)
    {
        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .FirstAsync(it => it.Id == id); 
        if (entity == null) {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Expire(entity);
        await _dbContext.SaveChangesAsync();

        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }


    public async Task<FareResponse> PayOfferAsync(int id) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();

        var entity = await _dbContext.FareOffers
            .Include(it => it.Fare)
            .FirstAsync(it => it.Id == id);
        if (entity == null) {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Pay(entity);
        await _fareService.PayAsync(entity!.Fare!.Id);

        await _dbContext.SaveChangesAsync();

        await transaction.CommitAsync();


        return await _fareService.GetByIdAsync(entity!.Fare!.Id);
    }


    public async Task<List<string>> AllowedActions(int id)
    {
        return await _baseFareOfferState.AllowedActions(id);
    }
}