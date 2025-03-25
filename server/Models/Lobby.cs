namespace Server.Models;

public class Lobby
{
    public string Code = Random.Shared.Next(100000).ToString("D5");
    public Player Host;
    public long Seed = Random.Shared.NextInt64();

    public List<Player> Players;

    public Lobby(Player host)
    {
        Host = host;
        Players = [Host];
    }
}
