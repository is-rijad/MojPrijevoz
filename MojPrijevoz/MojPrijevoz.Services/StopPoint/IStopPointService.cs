using MojPrijevoz.Model.Requests.StopPoint;
using MojPrijevoz.Model.Responses.StopPoint;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.StopPoint;

public interface IStopPointService : IBaseCRUDService<StopPointInsertRequest, StopPointInsertRequest, StopPointResponse, StopPointSearchObject>;