import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatthebomb/routes/lobby.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  final connection =
      HubConnectionBuilder()
          .withUrl(
            'http://10.0.2.2:5222/app',
            HttpConnectionOptions(
              transport: HttpTransportType.webSockets,
              logging: (_, msg) => dev.log(msg),
            ),
          )
          .build();
  bool connectionStarted = false;

  var codeTextCtl = TextEditingController();
  var nameTextCtl = TextEditingController(text: 'Player_1');

  Future<List<String>> joinGame() async {
    // TODO: Fix already future completed bug when creating a game twice
    final completer = Completer<List<String>>();

    if (!connectionStarted) {
      await connection.start();
      connectionStarted = true;
    }

    connection.on('joingameresponse', (msg) {
      if (msg == null || msg.length < 2 || msg[0] != "ok") {
        dev.log("msg was invalid", name: '$JoinGame');
        completer.complete(List<String>.empty());
        return;
      }

      completer.complete(msg[1].toString().split(';'));
    });

    await connection.invoke(
      'joingamerequest',
      args: [nameTextCtl.text, codeTextCtl.text],
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Join game'),
      ),
      body: Column(
        children: <Widget>[
          const Text('Lobby code'),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: codeTextCtl,
          ),
          const Text('My name'),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: nameTextCtl,
          ),
          TextButton(
            onPressed: () async {
              List<String> players = await joinGame();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          Lobby(lobbyCode: codeTextCtl.text, players: players),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Text('Enter lobby'),
          ),
        ],
      ),
    );
  }
}
