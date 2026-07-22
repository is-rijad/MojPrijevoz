namespace MojPrijevoz.Services.Helpers;

public class JsonDateTimeUtcConverter : System.Text.Json.Serialization.JsonConverter<DateTime> {
    public override DateTime Read(ref System.Text.Json.Utf8JsonReader reader, Type typeToConvert, System.Text.Json.JsonSerializerOptions options) {
        return reader.GetDateTime();
    }

    public override void Write(System.Text.Json.Utf8JsonWriter writer, DateTime value, System.Text.Json.JsonSerializerOptions options) {
        writer.WriteStringValue(value.ToString("yyyy-MM-ddTHH:mm:ss.fffZ"));
    }
}