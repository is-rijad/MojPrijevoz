using System.Globalization;

namespace MojPrijevoz.Recommender.Helpers;

public static class ZoneHelper
{
    private const double Precision = 0.01;

    public static string ToZoneKey(string lat, string lng)
    {
        var latBucket = Math.Floor(double.Parse(lat, CultureInfo.InvariantCulture) / Precision) * Precision;
        var lngBucket = Math.Floor(double.Parse(lng, CultureInfo.InvariantCulture) / Precision) * Precision;
        return $"{latBucket:F2}_{lngBucket:F2}";
    }
}