using Microsoft.AspNetCore.Mvc.Filters;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Services.Authorization;

namespace MojPrijevoz.WebApi.Filters;

public class AdminAuthorizationFilter : IAsyncActionFilter
{
    private readonly AuthorizationService _authorizationService;

    public AdminAuthorizationFilter(AuthorizationService authorizationService)
    {
        _authorizationService = authorizationService;
    }
    public Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        if (_authorizationService.GetAdminRole() != AdministratorRole.Admin)
        {
            throw new UnauthorizedException("Niste administrator!");
        }
        return next();
    }
}