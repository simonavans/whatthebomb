using Microsoft.AspNetCore.SignalR;
using Server.Models;

namespace Server;

public class AppHub : Hub
{
    public async Task CreateGameRequest(string playerName)
    {
        var player = new Player(playerName);
        var lobby = new Lobby(player);

        GameStore.ActiveLobbies.Add(lobby);
        await Clients.Caller.SendAsync("creategameresponse", "ok", lobby.Code);
    }

    public async Task JoinGameRequest(string playerName, string lobbyCode)
    {
        var lobby = GameStore.ActiveLobbies.FirstOrDefault(l => l.Code == lobbyCode);
        if (lobby == null)
        {
            await Clients.Caller.SendAsync("joingameresponse", "error", $"Lobby with code {lobbyCode} not found");
            return;
        }

        var playerInLobby = lobby.Players.FirstOrDefault(p => p.Name == playerName);
        if (playerInLobby != null)
        {
            await Clients.Caller.SendAsync("joingameresponse", "error", $"Client {playerName} has already joined the game");
            return;
        }

        lobby.Players.Add(new Player(playerName));

        // TODO: make sure the separator cannot be input as name
        await Clients.Others.SendAsync("joingameevent", playerName);
        await Clients.Caller.SendAsync("joingameresponse", "ok", string.Join(";", lobby.Players));
    }

    // TODO: make it so only host can start game
    public async Task StartGameRequest()
    {
        await Clients.All.SendAsync("startgameevent", Program.GenerateSeed().ToString());
    }

    public override async Task OnConnectedAsync()
    {
        Console.WriteLine($"Client connected: {Context.ConnectionId}");
        await base.OnConnectedAsync();
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        Console.WriteLine($"Client disconnected: {Context.ConnectionId}");
        await base.OnDisconnectedAsync(exception);
    }
}
