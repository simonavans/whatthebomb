namespace Server.Models;

public class Player(string name, string connectionId)
{
    public string Name = name;
    public string ConnectionId = connectionId;

    public override string ToString()
    {
        return Name;
    }
}
