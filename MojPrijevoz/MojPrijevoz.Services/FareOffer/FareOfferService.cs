using MapsterMapper;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.Fare;
using MojPrijevoz.Model.Requests.FareOffer;
using MojPrijevoz.Model.Responses.FareOffer;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.Fare;

namespace MojPrijevoz.Services.FareOffer;

public class FareOfferService : BaseCrudService<Database.FareOffer, FareOfferInsertRequest, FareOfferInsertRequest, FareOfferResponse, FareOfferSearchObject>, IFareOfferService {
    private readonly IFareService _fareService;

    public FareOfferService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService,
        IFareService fareService) : base(context, mapper, authorizationService) {
        _fareService = fareService;
    }

    protected override async Task BeforeInsert(FareOfferInsertRequest request) {
        if (await _fareService.HasActiveFareForRoute(request.PassengerId, _mapper.Map<HasActiveFareRequest>(request))) {
            throw new BadRequestException("Već imate zakazanu vožnju za istu rutu, na isti dan!");
        }

        await base.BeforeInsert(request);
    }

    public override async Task<FareOfferResponse> InsertWithTransactionAsync(FareOfferInsertRequest request) {
        var passengerId = (await _authorizationService.GetProfileId(ProfileType.Passenger))!.Value;
        await BeforeInsert(request);
        EntityEntry<Database.FareOffer>? entityEntry = null;
        foreach (var driversPrice in request.DriversPrices) {
            var fareRequest = MapToFareInsertRequest(passengerId, driversPrice, request);
            var fare = await _fareService.InsertAsync(fareRequest);

            request.FareId = fare.Id;
            request.Price = fare.Price;
            request.UserVehicleId = driversPrice.UserVehicleId;

            entityEntry ??= await _dbContext.FareOffers.AddAsync(MapToInsertEntity(request));
        }

        await _dbContext.SaveChangesAsync();
        return MapToResponseModel<FareOfferResponse>(entityEntry!.Entity, _mapper);
    }

    private FareInsertRequest MapToFareInsertRequest(int passengerId, FareOfferDriverPriceDto driverPrice, FareOfferInsertRequest fareOfferRequest) {
        var fareInsertRequest = _mapper.Map<FareInsertRequest>(fareOfferRequest);
        fareInsertRequest.DriverId = driverPrice.DriverId;
        fareInsertRequest.Price = driverPrice.Price;
        fareInsertRequest.PassengerId = passengerId;
        fareInsertRequest.DestinationLat = fareOfferRequest.DestinationCity.DestinationLat;
        fareInsertRequest.DestinationLong = fareOfferRequest.DestinationCity.DestinationLong;
        return fareInsertRequest;
    }

    protected override Database.FareOffer MapToInsertEntity(FareOfferInsertRequest request) {
        return new Database.FareOffer()
        {
            Side = FareOfferSide.Passenger,
            FareId = request.FareId,
            Price = request.Price,
            UserVehicleId = request.UserVehicleId
        };
    }
}