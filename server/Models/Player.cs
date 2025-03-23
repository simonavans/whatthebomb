namespace Server.Models;

public class Player(string name)
{
    public string Name = name;

    public override string ToString()
    {
        return Name;
    }
}
