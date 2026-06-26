
namespace MojPrijevoz.Database.Interfaces;

public interface IEntityHasPicture {
    public string? Picture { get; set; }
}

public static class EntityHasPictureExtension
{
    public static string? GetPicture(this IEntityHasPicture? entity) {
        // Check for origin because seeded entities
        if (entity?.Picture != null) {
            if (!entity.Picture.StartsWith("http")) {
                var baseUrl = Environment.GetEnvironmentVariable("Storage__Url")
                              ?? throw new InvalidOperationException("Storage__Url not set");
                return $"{baseUrl}{entity.Picture}";
            }

            return entity.Picture;
        }

        return null;
    }

}
