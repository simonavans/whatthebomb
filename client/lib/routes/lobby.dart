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
  });

  final HubConnection connection;
  final String lobbyCode;
  final List<String> players;

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

  Future<void> joinGameEvent() async {
    super.widget.connection.on('joingameevent', (message) {
      if (message != null && message.isNotEmpty) {
        setState(() {
          super.widget.players.insert(0, message[0]); // Insert at the top
        });
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
          TextButton(
            onPressed: () {
              dev.log(
                'lobbycode: ${super.widget.lobbyCode}, players: ${super.widget.players.join(', ')}',
                name: '$Lobby',
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Game()),
              // );
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Start game'),
          ),
        ],
      ),
    );
  }
}
