using Microsoft.AspNetCore.Http;

namespace MojPrijevoz.Services.FormRequests;

public interface IFormHasPicture
{
    public IFormFile? Picture { get; set; }
}