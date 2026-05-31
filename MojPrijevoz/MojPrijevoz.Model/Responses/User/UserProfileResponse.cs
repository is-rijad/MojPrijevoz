using System.Runtime.CompilerServices;
using System.Text.Json.Serialization;
using MojPrijevoz.Database;

namespace MojPrijevoz.Model.Responses.User;

public class UserProfileResponse
{
    public int Id { get; set; }
    public int NumberOfFares { get; set; }
    public short ProfileType { get; set; }
    public int UserId { get; set; }
    public UserResponse? User { get; set; }
    [JsonIgnore] public ICollection<Rating> RatingTos { get; set; } = null!;

    public float AverageReview => RatingTos.Count != 0 ? RatingTos.Sum(r => r.Grade) / (float)(RatingTos.Count) : 0;
    
}