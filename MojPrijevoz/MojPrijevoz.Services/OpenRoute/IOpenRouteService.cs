using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Model.Responses.OpenRoute;

namespace MojPrijevoz.Services.OpenRoute;

public interface IOpenRouteService
{
    public Task<GetDistanceResponse> GetDistance(GetDistanceRequest request);
}