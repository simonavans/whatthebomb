import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatthebomb/routes/game.dart';

class Lobby extends StatefulWidget {
  const Lobby({
    super.key,
    required this.connection,
    required this.lobbyCode,
    required this.players,
    required this.playerName,
    required this.isHost,
  });

  final HubConnection connection;
  final String lobbyCode;
  final List<String> players;
  final String playerName;
  final bool isHost;

  @override
  State<StatefulWidget> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    joinGameEvent();
  }

  Future<int> getSeed() async {
    final completer = Completer<int>();

    super.widget.connection.on('startgameevent', (msg) {
      if (msg == null || msg.isEmpty) {
        dev.log("msg was invalid", name: '$Lobby');
        completer.complete(-1);
        return;
      }

      completer.complete(int.parse(msg[0]));
    });

    await super.widget.connection.invoke('startgamerequest', args: []);

    return completer.future;
  }

  Future<void> joinGameEvent() async {
    super.widget.connection.on('joingameevent', (message) {
      if (message != null && message.isNotEmpty) {
        setState(() {
          super.widget.players.insert(0, message[0]); // Insert at the top
        });
      }
    });

    if (super.widget.isHost) return;

    super.widget.connection.on('startgameevent', (message) {
      if (message != null && message.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Game(
                  players: super.widget.players,
                  playerName: super.widget.playerName,
                  seed: int.parse(message[0]),
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Game lobby'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: super.widget.lobbyCode,
            ),
          ),
          const Text('Players'),
          ListView.builder(
            controller: scrollController,
            itemCount: super.widget.players.length,
            shrinkWrap: true,
            itemBuilder:
                (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(super.widget.players[index]),
                  ),
                ),
          ),
          super.widget.isHost
              ? TextButton(
                onPressed: () async {
                  int seed = await getSeed();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Game(
                            players: super.widget.players,
                            playerName: super.widget.playerName,
                            seed: seed,
                          ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Start game'),
              )
              : const Text("WAITING FOR HOST TO START"),
        ],
      ),
    );
  }
}
