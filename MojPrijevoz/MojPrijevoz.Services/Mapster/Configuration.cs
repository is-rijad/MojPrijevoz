using Mapster;
using MojPrijevoz.Database.Interfaces;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Model.Responses.UserVehicle;

namespace MojPrijevoz.Services.Mapster;

public class Configuration : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Database.User, UserResponse>()
            .Map(dest => dest.Picture, src => src.GetPicture());
        config.NewConfig<Database.UserVehicle, UserVehicleResponse>()
            .Map(dest => dest.Picture, src => src.GetPicture());
    }
}