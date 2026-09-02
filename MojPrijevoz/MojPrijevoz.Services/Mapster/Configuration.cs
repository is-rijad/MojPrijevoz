using Mapster;
using MojPrijevoz.Database.Interfaces;
using MojPrijevoz.Model.Responses.Rating;
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
        config.NewConfig<Database.UserProfile, RatingFromResponse>()
            .Map(dest => dest.FirstName, src => src.User!.FirstName)
            .Map(dest => dest.LastName, src => src.User!.LastName)
            .Map(dest => dest.Picture, src => src.User!.GetPicture());
    }
}