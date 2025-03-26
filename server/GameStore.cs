using Server.Models;

namespace Server;

public static class GameStore
{
    public static List<string> TakenCodes = [];

    public static List<Lobby> ActiveLobbies = [];

    public static Lobby? GetLobbyByConnId(String connId)
    {
        foreach (var lobby in ActiveLobbies)
        {
            if (lobby.Players.FirstOrDefault(p => p.ConnectionId == connId) != null)
                return lobby;
        }
        return null;
    }

    public static Player? GetPlayerByConnId(String connId)
    {
        foreach (var lobby in ActiveLobbies)
        {
            var player = lobby.Players.FirstOrDefault(p => p.ConnectionId == connId);
            if (player != null)
                return player;
        }
        return null;
    }
}
