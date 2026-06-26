using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using MojPrijevoz.Model.Exceptions;
using System.Net;

namespace MojPrijevoz.WebApi.Filters;

public class ExceptionFilter : ExceptionFilterAttribute {
    private readonly ILogger<ExceptionFilter> _logger;

    public ExceptionFilter(ILogger<ExceptionFilter> logger) {
        _logger = logger;
    }

    public override void OnException(ExceptionContext context) {
        _logger.LogError(context.Exception, context.Exception.Message);

        if (context.Exception is BadRequestException) {
            context.ModelState.AddModelError("badRequest", context.Exception.Message);
            context.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
        }
        else if (context.Exception is NotFoundException) {
            context.ModelState.AddModelError("notFound", context.Exception.Message);
            context.HttpContext.Response.StatusCode = (int)HttpStatusCode.NotFound;
        }
        else if (context.Exception is UnauthorizedException) {
            context.ModelState.AddModelError("unauthorized", context.Exception.Message);
            context.HttpContext.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
        }
        else if (context.Exception is ForbiddenException) {
            context.ModelState.AddModelError("forbidden", context.Exception.Message);
            context.HttpContext.Response.StatusCode = (int)HttpStatusCode.Forbidden;
        }
        else {
            context.ModelState.AddModelError("serverError", "Neočekivana greška!");
            context.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
        }

        var list = context.ModelState.Where(x => x.Value != null && x.Value.Errors.Count > 0)
            .ToDictionary(x => x.Key, y => y.Value?.Errors.Select(z => z.ErrorMessage));

        var lastError = list.SelectMany(x => x.Value!).Last();
        context.Result = new JsonResult(new
        {
            message = lastError,
            errors = list
        });
    }
}