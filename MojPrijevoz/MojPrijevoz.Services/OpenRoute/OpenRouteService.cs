using System.Net.Http.Headers;
using System.Net.Mime;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.OpenRoute;
using MojPrijevoz.Model.Responses.OpenRoute;
using MojPrijevoz.Services.City;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace MojPrijevoz.Services.OpenRoute;

public class OpenRouteService : IOpenRouteService
{
    private readonly CityService _cityService;
    private readonly HttpClient _httpClient;
    private readonly IConfigurationSection _openApiConfiguration;

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
            return new GetDistanceResponse { DistanceInKm = 0, DurationInMinutes = 0 };
        var cityFrom = await _cityService.GetByIdAsync(request.CityFrom);
        var cityTo = await _cityService.GetByIdAsync(request.CityTo);
        var internalRequest = new
        {
            Coordinates = new[]
            {
                new[] { cityFrom.Long, cityFrom.Lat },
                new[] { cityTo.Long, cityTo.Lat }
            },
            Radiuses = new[] { -1 },
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
        try
        {
            var response = await _httpClient.PostAsync(_openApiConfiguration["Url"], jsonRequest);
            var responseObject =
                await JsonSerializer.DeserializeAsync<JsonElement>(await response.Content.ReadAsStreamAsync());
            return new GetDistanceResponse
            {
                DistanceInKm = responseObject.GetProperty("routes")[0].GetProperty("summary").GetProperty("distance")
                    .GetDouble(),
                DurationInMinutes = responseObject.GetProperty("routes")[0].GetProperty("summary")
                    .GetProperty("duration").GetDouble() / 60
            };
        }
        catch (HttpRequestException e)
        {
            throw new BadRequestException("Previše uzastopnih slanja, pokušajte ponovo!");
        }
    }
}