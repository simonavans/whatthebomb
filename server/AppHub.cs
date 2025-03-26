using Microsoft.AspNetCore.SignalR;
using Server.Models;

namespace Server;

public class AppHub : Hub
{
    // TODO: Only send messages to clients in the same lobby!
    public async Task CreateGameRequest(string playerName)
    {
        var player = new Player(playerName, Context.ConnectionId);
        var lobby = new Lobby(player);

        GameStore.ActiveLobbies.Add(lobby);
        await Groups.AddToGroupAsync(Context.ConnectionId, lobby.Code);

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

        lobby.Players.Add(new Player(playerName, Context.ConnectionId));
        await Groups.AddToGroupAsync(Context.ConnectionId, lobby.Code);

        // TODO: make sure the separator cannot be input as name
        await Clients.Others.SendAsync("joingameevent", playerName);
        await Clients.Caller.SendAsync("joingameresponse", "ok", string.Join(";", lobby.Players));
    }

    // TODO: make it so only host can start game
    public async Task StartGameRequest()
    {
        var lobby = GameStore.GetLobbyByConnId(Context.ConnectionId);
        if (lobby != null)
            await Clients.Group(lobby.Code).SendAsync("startgameevent", lobby.Seed.ToString());
    }

    public async Task PassBombRequest(string sender, string receiver)
    {
        var lobby = GameStore.GetLobbyByConnId(Context.ConnectionId);
        if (lobby != null)
            await Clients.Group(lobby.Code).SendAsync("passbombevent", sender, receiver);
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
