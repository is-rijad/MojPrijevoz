using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Model.SearchObjects;

namespace MojPrijevoz.Services.SearchFare;

public interface ISearchFareService
{
    public Task<PagedResult<UserResponse>> Search(SearchFareSearchObject searchObject);
}