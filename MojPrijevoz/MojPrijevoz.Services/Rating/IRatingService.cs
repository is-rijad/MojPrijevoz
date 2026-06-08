using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Requests.Rating;
using MojPrijevoz.Model.Responses.Rating;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Rating;

public interface IRatingService : IBaseCRUDService<RatingInsertRequest, RatingInsertRequest, RatingResponse, BaseSearchObject>
{
    
}