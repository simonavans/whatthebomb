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
        builder.WebHost.UseUrls("http://localhost:5222");

        var app = builder.Build();

        app.UseRouting();
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapHub<AppHub>("/app");
        });
        app.UseCors("AllowAll");
        app.MapControllers();
        app.UseHttpsRedirection();

        app.Run();
    }

    public static long GenerateSeed()
    {
        return Random.Shared.NextInt64();
    }
}
