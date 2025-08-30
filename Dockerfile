FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["aks-ga-demo.csproj", "./"]
RUN dotnet restore "./aks-ga-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aks-ga-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aks-ga-demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aks-ga-demo.dll"]
