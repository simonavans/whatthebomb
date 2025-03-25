import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatthebomb/routes/joingame.dart';
import 'package:whatthebomb/routes/lobby.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({super.key});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  late HubConnection connection;

  TextEditingController textCtl = TextEditingController(text: 'Player_host');

  final ipTextCtl = TextEditingController(text: '192.168.');
  final portTextCtl = TextEditingController(text: '5222');

  Future<String?> createGame() async {
    // TODO: Fix already future completed bug when creating a game twice
    final completer = Completer<String?>();
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

    connection.on('creategameresponse', (msg) {
      if (msg == null || msg.length != 2 || msg[0] != "ok") {
        dev.log("msg was invalid", name: '$CreateGame');
        completer.complete(null);
        return;
      }

      dev.log(msg[1], name: '$JoinGame');

      connection.off('creategameresponse');
      completer.complete(msg[1]);
    });

    await connection.invoke('creategamerequest', args: [textCtl.text]);

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create game'),
      ),
      body: Column(
        children: <Widget>[
          const Text('Server IP address'),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: ipTextCtl,
          ),
          const Text('Server port'),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: portTextCtl,
          ),
          const Text('My name'),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: textCtl,
          ),
          const Text('Game settings'),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('Round length (seconds)'),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text('40-100'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text('100-200'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text('200-300'),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              String? lobbyCode = await createGame();

              if (lobbyCode != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Lobby(
                          connection: connection,
                          lobbyCode: lobbyCode,
                          players: [textCtl.text],
                          playerName: textCtl.text,
                          isHost: true,
                        ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Text('Create game'),
          ),
        ],
      ),
    );
  }
}
