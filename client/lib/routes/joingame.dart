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
  late HubConnection connection;

  var codeTextCtl = TextEditingController();
  var nameTextCtl = TextEditingController(text: 'Player_1');
  var ipTextCtl = TextEditingController(text: '192.168.');
  var portTextCtl = TextEditingController(text: '5222');

  Future<List<String>> joinGame() async {
    if (ipTextCtl.text.isEmpty || portTextCtl.text.isEmpty) {
      return [];
    }

    connection =
        HubConnectionBuilder()
            .withUrl(
              'http://${ipTextCtl.text}:${portTextCtl.text}/app',
              HttpConnectionOptions(
                transport: HttpTransportType.webSockets,
                logging: (_, msg) => dev.log(msg),
              ),
            )
            .build();
    await connection.start();

    final completer = Completer<List<String>>();

    connection.on('joingameresponse', (msg) {
      if (msg == null || msg.length < 2) {
        dev.log("msg was invalid", name: '$JoinGame');
        completer.complete(List<String>.empty());
        return;
      }
      if (msg[0] != "ok") {
        dev.log("msg was invalid: ${msg[0]}, ${msg[1]}", name: '$JoinGame');
        completer.complete(List<String>.empty());
        return;
      }

      connection.off('joingameresponse');
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text('Lobby code'),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: codeTextCtl,
            ),
            const SizedBox(height: 20),
            const Text('Server IP address'),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: ipTextCtl,
            ),
            const SizedBox(height: 20),
            const Text('Server port'),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: portTextCtl,
            ),
            const SizedBox(height: 20),
            const Text('My name'),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: nameTextCtl,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                List<String> players = await joinGame();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Lobby(
                          connection: connection,
                          lobbyCode: codeTextCtl.text,
                          players: players,
                          playerName: nameTextCtl.text,
                          isHost: false,
                        ),
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
      ),
    );
  }
}
