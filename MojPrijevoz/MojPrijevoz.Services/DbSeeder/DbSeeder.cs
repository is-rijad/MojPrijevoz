using Bogus;
using Bogus.Extensions;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.Services.DbSeeder;

public class DbSeeder {
    private readonly MojPrijevozDbContext _mojPrijevozDbContext;
    private readonly AuthorizationService _authorizationService;
    private readonly Randomizer _randomizer = new Randomizer();

    private const string FakerLocale = "hr";

    private List<Database.City>? _cities;
    private List<int>? _vehicleIds;
    private Queue<int>? _userIds;
    private List<int>? _passengerProfileIds;
    private List<int>? _driverProfileIds;
    private List<dynamic>? _userVehicles;
    private Queue<dynamic>? _fareDatas;
    private List<dynamic>? _fares;

    public DbSeeder(MojPrijevozDbContext mojPrijevozDbContext,
        AuthorizationService authorizationService) {
        _mojPrijevozDbContext = mojPrijevozDbContext;
        _authorizationService = authorizationService;
    }

    public async Task SeedAsync() {
        if (!(await CheckIsSeedNeededAsync())) {
            Console.WriteLine("Seeding database is not needed");
            return;
        }

        Console.WriteLine("Seeding database...");

        await using var transaction = await _mojPrijevozDbContext.Database.BeginTransactionAsync();

        await PrepareIds();

        await SeedUsersAsync();
        await SeedUserProfilesAsync();
        await SeedUserVehiclesAndDriverDiscountsAsync();

        await SeedFareDataAsync();
        await SeedFaresAsync();
        await SeedFareOffersAsync();
        await SeedRatingsAsync();

        await transaction.CommitAsync();
    }

    private async Task<bool> CheckIsSeedNeededAsync() {
        return !await _mojPrijevozDbContext.Users.AnyAsync();
    }

    private async Task PrepareIds() {
        _cities = await _mojPrijevozDbContext.Cities.ToListAsync();
        _vehicleIds = await _mojPrijevozDbContext.Vehicles.Select(c => c.Id).ToListAsync();

    }

    private async Task SeedUsersAsync() {
        _authorizationService.CreatePassword("Test123!", "Test123!", out var passwordHash, out var passwordSalt);

        var usersGen = new Faker<Database.User>(FakerLocale)
            .RuleFor(u => u.FirstName, f => f.Name.FirstName().ClampLength(max: 32))
            .RuleFor(u => u.LastName, f => f.Name.LastName().ClampLength(max: 64))
            .RuleFor(u => u.Username,
                (f, u) => f.Internet.UserName(u.FirstName, u.LastName).ClampLength(max: 96).ToLower())
            .RuleFor(u => u.Email, (f, u) => f.Internet.Email(u.FirstName, u.LastName).ClampLength(max: 96).ToLower())
            .RuleFor(u => u.PasswordHash, f => passwordHash)
            .RuleFor(u => u.PasswordSalt, f => passwordSalt)
            .RuleFor(u => u.CityId, f => f.PickRandom(_cities!.Select(c => c.Id)))
            .RuleFor(u => u.Status, f => f.PickRandom<AccountStatus>())
            .RuleFor(u => u.Picture, f => f.Image.PicsumUrl());

        var users = usersGen.Generate(50);
        await _mojPrijevozDbContext.Users.AddRangeAsync(users);
        await _mojPrijevozDbContext.SaveChangesAsync();

        _userIds = new Queue<int>(users.Select(u => u.Id));
    }

    private async Task SeedUserProfilesAsync() {
        var userProfiles = new List<Database.UserProfile>();
        while (_userIds!.Any()) {
            var userId = _userIds!.Dequeue();
            userProfiles.Add(new Database.UserProfile
            {
                UserId = userId,
                ProfileType = ProfileType.Passenger,
            });
            if (_randomizer.Bool(0.3f)) {
                var userProfile = new Database.UserProfile
                {
                    UserId = userId,
                    ProfileType = ProfileType.Driver,
                };
                userProfiles.Add(userProfile);
            }
        }

        await _mojPrijevozDbContext.UserProfiles.AddRangeAsync(userProfiles);
        await _mojPrijevozDbContext.SaveChangesAsync();

        _passengerProfileIds =
            new List<int>(userProfiles.Where(up => up.ProfileType == ProfileType.Passenger).Select(up => up.Id));

        _driverProfileIds =
            new List<int>(userProfiles.Where(up => up.ProfileType == ProfileType.Driver).Select(up => up.Id));
    }

    private async Task SeedUserVehiclesAndDriverDiscountsAsync() {
        var userVehicles = new List<Database.UserVehicle>();
        foreach (var userProfileId in _driverProfileIds!) {
            var userVehicleFaker = new Faker<Database.UserVehicle>(FakerLocale)
                .RuleFor(uv => uv.VehicleId, f => f.PickRandom(_vehicleIds))
                .RuleFor(uv => uv.ProfileId, f => userProfileId)
                .RuleFor(uv => uv.ModelYear, f => f.Random.Int(1990, DateTime.UtcNow.Year))
                .RuleFor(uv => uv.Status, f => f.PickRandom<UserVehicleStatus>())
                .RuleFor(uv => uv.LicensePlate, f => f.Random.Replace("?##-?-###"))
                .RuleFor(uv => uv.PricePerKm, f => f.Random.Float(0.1f, 2f))
                .RuleFor(uv => uv.Picture, f => GetRandomVehiclePicture());

            userVehicles.AddRange(userVehicleFaker.Generate(_randomizer.Int(1, 6)));
            userVehicles.Last().Status = UserVehicleStatus.Active;

            await SeedUserDiscounts(userProfileId);


        }
        await _mojPrijevozDbContext.UserVehicles.AddRangeAsync(userVehicles);
        await _mojPrijevozDbContext.SaveChangesAsync();
        _userVehicles = new List<dynamic>(userVehicles.Select(uv => new { Id = uv.Id, Status = uv.Status, ProfileId = uv.ProfileId }));
    }

    private string GetRandomVehiclePicture() {
        // Hardcoded just to have some picture for user vehicles, since seeding real pictures would be more complex and time consuming
        return $"https://loremflickr.com/320/240/car?random={_randomizer.Int(1, 1000)}";
    }

    private async Task SeedUserDiscounts(int driverUserProfileId) {
        var discounts = new List<Database.DriversDiscount>();
        var count = _randomizer.Int(0, 6);
        var currentMin = 0f;

        for (int i = 0; i < count; i++) {
            var isLast = i == count - 1;
            var maxKm = isLast && _randomizer.Bool(0.3f)
                ? (float?)null
                : currentMin + _randomizer.Float(10, 100);

            discounts.Add(new Database.DriversDiscount
            {
                ProfileId = driverUserProfileId,
                MinKm = currentMin,
                MaxKm = maxKm,
                Discount = Math.Min((float)Math.Round((currentMin + _randomizer.Int(10, 50)) / 5f, 1), 100f)
            });

            currentMin = maxKm ?? currentMin + 200;
        }

        await _mojPrijevozDbContext.DriversDiscounts.AddRangeAsync(discounts);
        await _mojPrijevozDbContext.SaveChangesAsync();

    }

    private async Task SeedFareDataAsync() {
        var fareDataFaker = new Faker<Database.FareData>()
            .RuleFor(fd => fd.OriginCityId, (f, fd) =>
            {
                var city = f.PickRandom(_cities!);
                fd.OriginCityId = city.Id;
                fd._originLat = city.Lat;
                fd._originLong = city.Long;
                return city.Id;
            })
            .RuleFor(fd => fd.DestinationName, (f, fd) =>
            {
                var city = f.PickRandom(_cities!.Where(c => c.Id != fd.OriginCityId));
                fd.DestinationLat = city.Lat;
                fd.DestinationLong = city.Long;
                return city.Name;
            })
            .RuleFor(fd => fd.Length, f => f.Random.Int(5, 500))
            .RuleFor(fd => fd.Duration, (f, fd) =>
            {
                switch (fd.Length) {
                    case < 20:
                        return f.Random.Int(10, 30);
                    case < 100:
                        return f.Random.Int(30, 120);
                    case < 200:
                        return f.Random.Int(120, 240);
                    case < 300:
                        return f.Random.Int(240, 360);
                    case < 400:
                        return f.Random.Int(360, 480);
                    case < 500:
                        return f.Random.Int(480, 600);
                    case >= 500:
                        return f.Random.Int(600, 1440);
                }
            })
            .RuleFor(fd => fd.FareDateTime, f => f.Date.Future())
            .RuleFor(fd => fd.StopPoints, (f, fd) =>
            {
                var count = f.Random.Int(0, 3);
                return Enumerable.Range(1, count).Select(i =>
                {
                    var t = (float)i / (count + 1);
                    return new Database.StopPoint
                    {
                        Order = (short)i,
                        Lat = (double.Parse(fd._originLat) +
                               t * (double.Parse(fd.DestinationLat) - double.Parse(fd._originLat)) +
                               f.Random.Double(-0.05, 0.05)).ToString("F6"),
                        Long = (double.Parse(fd._originLong) +
                                t * (double.Parse(fd.DestinationLong) - double.Parse(fd._originLong)) +
                                f.Random.Double(-0.05, 0.05)).ToString("F6"),
                        Name = "Mjesto zaustavljanja " + (i + 1)
                    };
                }).ToList();
            });

        var fareDataList = fareDataFaker.Generate(100);

        await _mojPrijevozDbContext.FareData.AddRangeAsync(fareDataList);
        await _mojPrijevozDbContext.SaveChangesAsync();

        _fareDatas = new Queue<dynamic>(fareDataList.Select(fd => new { Id = fd.Id, FareDateTime = fd.FareDateTime }));
    }

    private async Task SeedFaresAsync() {
        var fareList = new List<Database.Fare>();
        while (_fareDatas!.Any()) {
            var fareData = _fareDatas!.Dequeue();
            int fareDataId = (int)fareData.Id;
            var fareFaker = new Faker<Database.Fare>(FakerLocale)
                .RuleFor(f => f.DriverId, f => f.PickRandom(_driverProfileIds))
                .RuleFor(f => f.PassengerId, f => f.PickRandom(_passengerProfileIds))
                .RuleFor(f => f.Status, f => f.PickRandom<FareStatus>())
                .RuleFor(f => f.FareDataId, f => fareData.Id)
                .RuleFor(f => f.FareStartAfter, f => fareData.FareDateTime.AddHours(-6))
                .RuleFor(f => f.UserVehicleId, (f, fare) => f.PickRandom(_userVehicles!.Where(it => it.ProfileId == fare.DriverId && it.Status == UserVehicleStatus.Active).Select(it => it.Id)));
            var fare = fareFaker.Generate();

            if (fare.UserVehicleId != null)
                fareList.Add(fareFaker.Generate());
            else
                _mojPrijevozDbContext.FareData.Remove(await _mojPrijevozDbContext.FareData.FirstAsync(fd => fd.Id == fareDataId));
        }

        await _mojPrijevozDbContext.Fares.AddRangeAsync(fareList);
        await _mojPrijevozDbContext.SaveChangesAsync();
        _fares = new List<dynamic>(fareList.Select(f => new { Id = f.Id, Status = f.Status, DriverId = f.DriverId, PassengerId = f.PassengerId }));

    }

    private async Task SeedFareOffersAsync() {
        var fareOfferList = new List<Database.FareOffer>();
        foreach (var fare in _fares!) {
            var count = _randomizer.Int(3, 8);
            var basePrice = _randomizer.Float(10, 80);

            for (int i = 0; i < count; i++) {
                var isLast = i == count - 1;
                var f = new Faker(FakerLocale);

                var variance = basePrice * 0.2f * (1f - (float)i / count);
                var price = basePrice + _randomizer.Float(-variance, variance);
                var additionalPrice = price + _randomizer.Float(-variance, variance);

                fareOfferList.Add(new Database.FareOffer
                {
                    FareId = fare.Id,
                    Side = i % 2 == 0 ? ProfileType.Passenger : ProfileType.Driver,
                    Status = isLast
                        ? f.PickRandom(Enum.GetValues<FareOfferStatus>().Where(it => it != FareOfferStatus.Expired))
                        : FareOfferStatus.Expired,
                    Price = (float)Math.Round(price, 2),
                    AdditionalPrice = f.Random.Bool(0.2f) ? (float)Math.Round(additionalPrice, 2) : null,
                });
            }

            var lastOffer = fareOfferList.Last();
            var fareToUpdate = await _mojPrijevozDbContext.Fares.FindAsync(fare.Id);
            fareToUpdate!.Status = GetFareStatusForOffer(lastOffer.Status);

            fareOfferList.Add(lastOffer);
        }

        await _mojPrijevozDbContext.FareOffers.AddRangeAsync(fareOfferList);
        await _mojPrijevozDbContext.SaveChangesAsync();
    }

    private FareStatus GetFareStatusForOffer(FareOfferStatus offerStatus) {
        return offerStatus switch
        {
            FareOfferStatus.Expired => FareStatus.Expired,
            FareOfferStatus.WaitingForResponse => FareStatus.InNegotiation,
            FareOfferStatus.Rejected => FareStatus.Rejected,
            FareOfferStatus.Accepted => _randomizer.Bool(0.5f) ? FareStatus.Accepted : FareStatus.Cancelled,
            FareOfferStatus.Payed => _randomizer.Bool(0.5f) ? FareStatus.Payed : FareStatus.Completed,
            FareOfferStatus.Cancelled => FareStatus.Cancelled,
            _ => throw new ArgumentOutOfRangeException(nameof(offerStatus), offerStatus, null)
        };
    }

    private async Task SeedRatingsAsync() {
        var allRatings = new List<Database.Rating>();
        foreach (var fare in _fares!.Where(it => it.Status == FareStatus.Completed)) {
            var ratingFaker = new Faker<Database.Rating>(FakerLocale)
                .RuleFor(r => r.FareId, f => fare.Id)
                .RuleFor(r => r.Grade, f => (short)f.Random.Int(1, 5))
                .RuleFor(r => r.Comment, f => f.Lorem.Sentence().ClampLength(max: 256));

            var ratings = ratingFaker.Generate(2);
            ratings[0].FromId = ratings[1].ToId = fare.DriverId;
            ratings[1].FromId = ratings[0].ToId = fare.PassengerId;
            allRatings.AddRange(ratings);
        }
        await _mojPrijevozDbContext.Ratings.AddRangeAsync(allRatings);
        await _mojPrijevozDbContext.SaveChangesAsync();
    }
}