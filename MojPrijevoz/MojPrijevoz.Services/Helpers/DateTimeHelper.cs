namespace MojPrijevoz.Services.Helpers;

public static class DateTimeHelper
{
    private static readonly TimeZoneInfo SarajevoTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Europe/Sarajevo");

    public static DateTime ToSarajevoTime(this DateTime utcDateTime)
    {
        return TimeZoneInfo.ConvertTimeFromUtc(DateTime.SpecifyKind(utcDateTime, DateTimeKind.Utc),
            SarajevoTimeZone);
    }
}
