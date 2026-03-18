using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Model.Responses.OpenRoute;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Net.Mime;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using MojPrijevoz.Services.City;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace MojPrijevoz.Services.OpenRoute;

public class OpenRouteService : IOpenRouteService
{
    private readonly IConfigurationSection _openApiConfiguration;
    private readonly HttpClient _httpClient;
    private readonly CityService _cityService;

    public OpenRouteService(IConfiguration configuration, IHttpClientFactory httpClientFactory,
        CityService cityService)
    {
        _openApiConfiguration = configuration.GetSection("OpenRouteApi");
        _httpClient = httpClientFactory.CreateClient();
        _cityService = cityService;
    }

    public async Task<GetDistanceResponse> GetDistance(GetDistanceRequest request)
    {
        if (request.CityFrom == request.CityTo)
        {
            return new GetDistanceResponse() { Distance = 0, Duration = 0 };
        }
        var cityFrom = await _cityService.GetByIdAsync(request.CityFrom);
        var cityTo = await _cityService.GetByIdAsync(request.CityTo);
        var internalRequest = new
        {
            Coordinates = new[]
            {
                new [] { cityFrom.Long, cityFrom.Lat },
                new [] { cityTo.Long, cityTo.Lat },
            },
            Radiuses = new int[] { -1 },
            Units = "km",
            Instructions = false,
            Geometry = false
        };
        using StringContent jsonRequest = new(
            JsonSerializer.Serialize(internalRequest, new JsonSerializerOptions(JsonSerializerDefaults.Web)),
            Encoding.UTF8,
            MediaTypeNames.Application.Json);
        _httpClient.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", _openApiConfiguration["Key"]!);
        var response = await _httpClient.PostAsync(_openApiConfiguration["Url"], jsonRequest);
        var responseObject = await JsonSerializer.DeserializeAsync<JsonElement>(await response.Content.ReadAsStreamAsync());
        return new GetDistanceResponse()
        {
            Distance = responseObject.GetProperty("routes")[0].GetProperty("summary").GetProperty("distance").GetDouble(),
            Duration = responseObject.GetProperty("routes")[0].GetProperty("summary").GetProperty("duration").GetDouble(),
        };
    }
}