using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Text;
using MojPrijevoz.Services.InMemoryDatabase;

namespace MojPrijevoz.Services.Authorization;

public static class AuthorizationConfiguration {
    public static void ConfigureAuthorization(this IServiceCollection services, IConfiguration configuration) {
        var jwtSettings = configuration.GetSection("Jwt");
        services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.Events = new JwtBearerEvents
                {
                    OnTokenValidated =  context =>
                    {
                        if (!int.TryParse(context.Principal?.FindFirst("sub")?.Value, out var userId))
                        {
                            context.Fail("Missing subject claim.");
                            return Task.CompletedTask;
                        }

                        var revokedTokenService =
                            context.HttpContext.RequestServices.GetRequiredService<RevokedTokenService>();
                        var revokedAt = revokedTokenService.GetRevokedRecord(userId);
                        if (revokedAt != null)
                        {
                            var issuedAtClaim = context.Principal?.FindFirst("iat")?.Value;
                            var issuedAt = issuedAtClaim is not null
                                ? DateTimeOffset.FromUnixTimeSeconds(long.Parse(issuedAtClaim)).UtcDateTime
                                : DateTime.MinValue;

                            if (issuedAt <= revokedAt)
                                context.Fail("Token revoked.");
                        }
                        return Task.CompletedTask;
                    }
                };
                options.RequireHttpsMetadata = true;
                options.SaveToken = true;
                options.MapInboundClaims = false;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    NameClaimType = "sub",
                    ValidateIssuer = true,
                    ValidateLifetime = true,
                    ValidateAudience = false,
                    ValidateIssuerSigningKey = true,
                    RoleClaimType = "role",
                    ValidIssuer = jwtSettings["Issuer"] ??
                                  throw new InvalidOperationException("Jwt Issuer is not configured!"),
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Key"] ??
                        throw new InvalidOperationException("Jwt Key is not configured!")))
                };
            });
        services.AddAuthorization();
    }

    public static void ConfigureControllerAuthorization(this MvcOptions config) {
        var policy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();
        config.Filters.Add(new AuthorizeFilter(policy));
    }

    public static void ConfigureSwaggerAuthorization(this SwaggerGenOptions options) {
        options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
        {
            Name = "Authorization",
            Type = SecuritySchemeType.Http,
            Scheme = "bearer",
            BearerFormat = "JWT",
            In = ParameterLocation.Header,
            Description = "Unesite JWT token u formatu: Bearer {token}"
        });

        options.AddSecurityRequirement(new OpenApiSecurityRequirement
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                    }
                },
                Array.Empty<string>()
            }
        });
    }
}