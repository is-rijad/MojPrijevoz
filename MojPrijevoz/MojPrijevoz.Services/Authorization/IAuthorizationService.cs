using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;

namespace MojPrijevoz.Services.Authorization;

public interface IAuthorizationService
{
    public Task<UserLoginResponse> Login(UserLoginRequest request);
    public void CreatePassword(string password, string passwordAgain, out string hash, out string salt);
    bool VerifyPassword(string password, string storedHash, string storedSalt);
}