using Microsoft.AspNetCore.Mvc;

namespace MojPrijevoz.WebApi.Filters;

public class ImageSizeFilterAttribute : RequestSizeLimitAttribute
{
    public ImageSizeFilterAttribute() : base(5 * 1024 * 1024)
    {
    }

    public ImageSizeFilterAttribute(long bytes) : base(bytes)
    {
    }
}