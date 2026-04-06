using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.SearchFare;
using MojPrijevoz.Model.SearchObjects;

namespace MojPrijevoz.Services.SearchFare;

public interface ISearchFareService {
    public Task<PagedResult<SearchFareResponse>> Search(SearchFareSearchObject searchObject);
    public Task<SearchFareDriverResponse> SearchDriver(int profileId, SearchFareDriverSearchObject searchObject);
}