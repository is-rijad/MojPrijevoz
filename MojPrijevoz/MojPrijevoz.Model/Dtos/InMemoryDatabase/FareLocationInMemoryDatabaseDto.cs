using MojPrijevoz.Model.Dtos.Nominatim;

namespace MojPrijevoz.Model.Dtos.InMemoryDatabase;

public class FareLocationInMemoryDatabaseDto : BaseInMemoryDatabaseDto {
    public NominatimCityDto LatLong { get; set; } = null!;
}