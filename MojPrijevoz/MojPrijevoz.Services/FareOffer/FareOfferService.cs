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
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.FareData;
using MojPrijevoz.Services.FareOffer.StateMachine;
using MojPrijevoz.Services.StopPoint;

namespace MojPrijevoz.Services.FareOffer;

public class FareOfferService : BaseCrudService<Database.FareOffer, FareOfferInsertRequest, FareOfferUpdateRequest, FareOfferResponse, FareOfferSearchObject>, IFareOfferService {
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

    public override async Task<FareOfferResponse> InsertWithTransactionAsync(FareOfferInsertRequest request) {
        await using var transaction = await _dbContext.Database.BeginTransactionAsync();
        var passengerId = (await _authorizationService.GetProfileId(ProfileType.Passenger))!.Value;
        await BeforeInsert(request);

        var fareDataRequest = _mapper.Map<FareDataInsertRequest>(request);
        fareDataRequest.DestinationLat = request.DestinationCity.DestinationLat;
        fareDataRequest.DestinationLong = request.DestinationCity.DestinationLong;
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

            entityEntry ??= await _dbContext.FareOffers.AddAsync(MapToInsertEntity(request));
            var baseStateMachine = _baseFareOfferState.GetState(null);
            baseStateMachine.Create(entityEntry.Entity);
        }

        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        return MapToResponseModel<FareOfferResponse>(entityEntry!.Entity, _mapper);
    }

    public override async Task<FareOfferResponse> UpdateAsync(int id, FareOfferUpdateRequest request) {
        var entity = await _dbContext.FareOffers.AsNoTracking().FirstAsync(it => it.Id == id);
        if (entity == null)
            throw new NotFoundException("Nije pronađeno!");
        var state = _baseFareOfferState.GetState(null);
        state.Expire(entity);
        await BeforeUpdate(id, request, entity);
        MapToUpdateEntity(request, entity);
        state = _baseFareOfferState.GetState(null);
        state.Create(entity);
        await _dbContext.FareOffers.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
        return MapToResponseModel<FareOfferResponse>(entity, _mapper);
    }

    protected override void MapToUpdateEntity(FareOfferUpdateRequest request, Database.FareOffer entity)
    {
        base.MapToUpdateEntity(request, entity);
        if (entity.Side == ProfileType.Passenger) {
            entity.Side = ProfileType.Driver;
        }
        else
        {
            entity.Side = ProfileType.Passenger;
        }
    }

    private FareInsertRequest MapToFareInsertRequest(int passengerId, int fareDataId, FareOfferDriverPriceDto driverPrice, FareOfferInsertRequest fareOfferRequest) {
        var fareInsertRequest = _mapper.Map<FareInsertRequest>(fareOfferRequest);
        fareInsertRequest.DriverId = driverPrice.DriverId;
        fareInsertRequest.PassengerId = passengerId;
        fareInsertRequest.FareDataId = fareDataId;
        return fareInsertRequest;
    }

    protected override Database.FareOffer MapToInsertEntity(FareOfferInsertRequest request)
    {
        return new Database.FareOffer()
        {
            Side = ProfileType.Passenger,
            FareDataId = request.FareDataId,
            Price = request.Price,
            AdditionalPrice = request.AdditionalPrice,
            UserVehicleId = request.UserVehicleId,
            LastOfferId = request.LastOfferId
        };
    }

    public async Task<FareOfferResponse> AcceptOfferAsync(int id)
    {
        var entity = await _dbContext.FareOffers.FindAsync(id);
        if (entity == null)
        {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Accept(entity);
        return MapToResponseModel<FareOfferResponse>(entity, _mapper);
    }

    public async Task<FareOfferResponse> RejectOfferAsync(int id) {
        var entity = await _dbContext.FareOffers.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Reject(entity);
        return MapToResponseModel<FareOfferResponse>(entity, _mapper);
    }

    public async Task<FareOfferResponse> ExpireOfferAsync(int id)
    {
        var entity = await _dbContext.FareOffers.FindAsync(id);
        if (entity == null) {
            throw new NotFoundException("Ponuda nije pronađena!");
        }
        var state = _baseFareOfferState.GetState((short)entity.Status);
        state.Expire(entity);
        return MapToResponseModel<FareOfferResponse>(entity, _mapper);
    }


    public async Task<List<string>> AllowedActions(int id)
    {
        return await _baseFareOfferState.AllowedActions(id);
    }
}