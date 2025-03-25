using System.Net;

namespace Server;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddCors(options =>
        {
            options.AddPolicy("AllowAll", policy =>
                    policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
        });
        builder.Services.AddSignalR();
        builder.Services.AddControllers();
        builder.WebHost.UseUrls("http://0.0.0.0:5222");

        var app = builder.Build();

        app.UseRouting();
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapHub<AppHub>("/app");
        });
        app.UseCors("AllowAll");
        app.MapControllers();
        app.UseHttpsRedirection();

        Console.WriteLine($"Running on {Dns.GetHostAddresses(Dns.GetHostName())[0]}");

        app.Run();
    }

    public static long GenerateSeed()
    {
        return Random.Shared.NextInt64();
    }
}
