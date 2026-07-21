using FirebaseAdmin.Messaging;
using Mapster.Utils;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MojPrijevoz.Database;
using MojPrijevoz.Model.Dtos.Notifications;
using Notification = MojPrijevoz.Database.Notification;

namespace MojPrijevoz.Notifications.NotificationService;

public class NotificationService : INotificationService
{
    private readonly IServiceScopeFactory _scopeFactory;

    public NotificationService(IServiceScopeFactory scopeFactory)
    {
        _scopeFactory = scopeFactory;
    }

    public async Task SubscribeToFcmAsync(SubscribeToFcmDto dto)
    {
        await UpsertUserFcmTokenAsync(dto);
        Console.WriteLine($"UserId: {dto.UserId} subscribed to FCM!");
    }

    public async Task UnsubscribeFromFcm(UnSubscribeFromFcmDto dto)
    {
        await DeleteFcmTokenAsync(dto);
        Console.WriteLine($"UserId: {dto.UserId} unsubscribed from FCM!");
    }

    public async Task SendToUserAsync(SendToUserDto dto)
    {
        using var scope = _scopeFactory.CreateScope();
        var dbContext = scope.ServiceProvider
            .GetRequiredService<MojPrijevozDbContext>();

        dto.Data.TryGetValue("RatingId", out var ratingId);

        await dbContext.Notifications.AddAsync(new Notification
        {
            CreatedAt = DateTime.Now,
            FareId = int.Parse(dto.Data["FareId"]),
            Side = Enum<ProfileType>.Parse(dto.Data["Side"]),
            Id = 0,
            IsRead = false,
            UserId = dto.UserId,
            Message = dto.Body,
            Type = dto.Data["Type"],
            RatingId = !string.IsNullOrEmpty(ratingId) ? int.Parse(ratingId) : null
        });
        await dbContext.SaveChangesAsync();

        var token = await dbContext.UserFcmTokens.FirstOrDefaultAsync(it => it.UserId == dto.UserId);
        if (token == null) return;

        var message = new Message
        {
            Token = token.Token,
            Notification = new FirebaseAdmin.Messaging.Notification
            {
                Title = dto.Title,
                Body = dto.Body
            },
            Data = dto.Data,
            Android = new AndroidConfig
            {
                Priority = Priority.High
            }
        };

        try
        {
            await FirebaseMessaging.DefaultInstance.SendAsync(message);

            Console.WriteLine($"Message {message.Data["Type"]} is sent to user {dto.UserId}");
        }
        catch (FirebaseMessagingException ex)
        {
            await HandleFirebaseException(ex, token);
        }
    }

    public async Task SendSilentToUserAsync(SendSilentToUserDto dto)
    {
        using var scope = _scopeFactory.CreateScope();
        var dbContext = scope.ServiceProvider
            .GetRequiredService<MojPrijevozDbContext>();

        var token = await dbContext.UserFcmTokens.FirstOrDefaultAsync(it => it.UserId == dto.UserId);
        if (token == null) return;

        var message = new Message
        {
            Token = token.Token,
            Data = dto.Data,
            Android = new AndroidConfig
            {
                Priority = Priority.High
            }
        };

        try
        {
            await FirebaseMessaging.DefaultInstance.SendAsync(message);

            Console.WriteLine($"Message {message.Data["Type"]} is sent to user {dto.UserId}");
        }
        catch (FirebaseMessagingException ex)
        {
            await HandleFirebaseException(ex, token);
        }
    }

    private async Task<UserFcmToken> UpsertUserFcmTokenAsync(SubscribeToFcmDto dto)
    {
        using var scope = _scopeFactory.CreateScope();
        var dbContext = scope.ServiceProvider
            .GetRequiredService<MojPrijevozDbContext>();

        var entity = await dbContext.UserFcmTokens
            .FirstOrDefaultAsync(x => x.UserId == dto.UserId);

        if (entity != null)
            entity.Token = dto.Token;
        else
            entity = (await dbContext.UserFcmTokens.AddAsync(new UserFcmToken
            {
                UserId = dto.UserId,
                Token = dto.Token,
                Platform = dto.Platform
            })).Entity;

        await dbContext.SaveChangesAsync();
        return entity;
    }

    private async Task DeleteFcmTokenAsync(UnSubscribeFromFcmDto dto)
    {
        using var scope = _scopeFactory.CreateScope();
        var dbContext = scope.ServiceProvider
            .GetRequiredService<MojPrijevozDbContext>();

        var entity = await dbContext.UserFcmTokens
            .FirstOrDefaultAsync(x => x.UserId == dto.UserId);

        if (entity != null)
        {
            dbContext.Remove(entity);
            await dbContext.SaveChangesAsync();
        }
    }

    private async Task HandleFirebaseException(FirebaseMessagingException ex, UserFcmToken token)
    {
        switch (ex.MessagingErrorCode)
        {
            case MessagingErrorCode.Unregistered:
                await DeleteFcmTokenAsync(new UnSubscribeFromFcmDto { UserId = token.UserId });
                Console.WriteLine($"FCM token deleted for user {token.UserId}");
                break;

            case MessagingErrorCode.InvalidArgument:
                await DeleteFcmTokenAsync(new UnSubscribeFromFcmDto { UserId = token.UserId });
                Console.WriteLine($"Invalid FCM token for user {token.UserId}");
                break;

            case MessagingErrorCode.QuotaExceeded:
                Console.WriteLine("FCM quota exceeded");
                break;

            default:
                Console.WriteLine($"FCM send failed for user {token.UserId}");
                break;
        }
    }
}