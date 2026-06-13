
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080


FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["MojPrijevoz.WebApi/MojPrijevoz.WebApi.csproj", "MojPrijevoz.WebApi/"]
RUN dotnet restore "./MojPrijevoz.WebApi/MojPrijevoz.WebApi.csproj"
COPY . .
WORKDIR "/src/MojPrijevoz.WebApi"
RUN dotnet build "./MojPrijevoz.WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./MojPrijevoz.WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MojPrijevoz.WebApi.dll"]