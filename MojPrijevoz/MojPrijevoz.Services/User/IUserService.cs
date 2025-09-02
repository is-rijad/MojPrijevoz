using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;

namespace MojPrijevoz.Services.User;

public interface IUserService
{
    Task CreateUser(UserInsertRequest request);
    Task<UserLoginResponse> Login(UserLoginRequest request);
    bool VerifyPassword(string password, string storedHash, string storedSalt);
}