using MapsterMapper;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Authorization;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Requests.FareData;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare;
using MojPrijevoz.Services.FareData;

namespace MojPrijevoz.Services.FareOffer;

public class FareOfferService : BaseCrudService<Database.FareOffer, FareOfferInsertRequest, FareOfferInsertRequest, FareOfferResponse, FareOfferSearchObject>, IFareOfferService {
    private readonly IFareService _fareService;
    private readonly IFareDataService _fareDataService;

    public FareOfferService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        IFareService fareService, IFareDataService fareDataService) : base(context, mapper, authorizationService) {
        _fareService = fareService;
        _fareDataService = fareDataService;
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

        EntityEntry<Database.FareOffer>? entityEntry = null;
        foreach (var driversPrice in request.DriversPrices) {
            var fareRequest = MapToFareInsertRequest(passengerId, fareData.Id, driversPrice, request);
            var fare = await _fareService.InsertAsync(fareRequest);

            request.Price = fare.Price;
            request.UserVehicleId = driversPrice.UserVehicleId;
            request.FareDataId = fareData.Id;

            entityEntry ??= await _dbContext.FareOffers.AddAsync(MapToInsertEntity(request));
        }

        await _dbContext.SaveChangesAsync();
        await transaction.CommitAsync();
        return MapToResponseModel<FareOfferResponse>(entityEntry!.Entity, _mapper);
    }

    private FareInsertRequest MapToFareInsertRequest(int passengerId, int fareDataId, FareOfferDriverPriceDto driverPrice, FareOfferInsertRequest fareOfferRequest) {
        var fareInsertRequest = _mapper.Map<FareInsertRequest>(fareOfferRequest);
        fareInsertRequest.DriverId = driverPrice.DriverId;
        fareInsertRequest.Price = driverPrice.Price;
        fareInsertRequest.PassengerId = passengerId;
        fareInsertRequest.FareDataId = fareDataId;
        return fareInsertRequest;
    }

    protected override Database.FareOffer MapToInsertEntity(FareOfferInsertRequest request)
    {
        return new Database.FareOffer()
        {
            Side = FareOfferSide.Passenger,
            FareDataId = request.FareDataId,
            Price = request.Price,
            UserVehicleId = request.UserVehicleId
        };
    }   
}