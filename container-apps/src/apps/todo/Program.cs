using System;
using System.Threading.Tasks;
using Azure.Identity;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using todo;
using todo.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration
    .AddJsonFile("appsettings.local.json", optional: true, reloadOnChange: true); //load local settings

builder.Services.AddControllersWithViews();
builder.Services.AddApplicationInsightsTelemetry();
builder.Services
    .AddSingleton<ICosmosDbService>(InitializeCosmosClientInstanceAsync(builder.Configuration.GetSection("CosmosDb"))
        .GetAwaiter().GetResult());


// -------------------
// App pipeline
// -------------------
var app = builder.Build();
if (builder.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
    app.UseHttpsRedirection();
}

app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
app.UseEndpoints(endpoints =>
{
    endpoints.MapControllerRoute(
        name: "default",
        pattern: "{controller=Item}/{action=Index}/{id?}");
});
app.Run();

// public class Program
// {
//     public static void Main(string[] args)
//     {
//         CreateWebHostBuilder(args).Build().Run();
//     }
//
//     public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
//         WebHost.CreateDefaultBuilder(args)
//             .UseStartup<Startup>();
// }

static async Task<CosmosDbService> InitializeCosmosClientInstanceAsync(IConfigurationSection configurationSection)
{
    var databaseName = configurationSection.GetSection("DatabaseName").Value;
    var containerName = configurationSection.GetSection("ContainerName").Value;
    var endpoint = configurationSection.GetSection("Endpoint").Value;
    if (string.IsNullOrEmpty(endpoint))
        endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT")!;

    // If key is not set, assume we're using managed identity
    Microsoft.Azure.Cosmos.CosmosClient client;
    var key = configurationSection.GetSection("Key").Value;
    if (string.IsNullOrEmpty(key))
        key = Environment.GetEnvironmentVariable("COSMOS_KEY")!;
    if (string.IsNullOrEmpty(key))
    {
        var miCredential = new ManagedIdentityCredential();
        client = new Microsoft.Azure.Cosmos.CosmosClient(endpoint, miCredential);
    }
    else
    {
        client = new Microsoft.Azure.Cosmos.CosmosClient(endpoint, key);
    }
            
    var cosmosDbService = new CosmosDbService(client, databaseName, containerName);
    var database = await client.CreateDatabaseIfNotExistsAsync(databaseName);
    await database.Database.CreateContainerIfNotExistsAsync(containerName, "/id");

    return cosmosDbService;
}