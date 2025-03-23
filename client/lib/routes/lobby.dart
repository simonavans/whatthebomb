import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:whatthebomb/routes/game.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key, required this.lobbyCode, required this.players});
  final String lobbyCode;
  final List<String> players;

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
              hintText: lobbyCode,
            ),
          ),
          const Text('Players'),
          Container(height: 50, color: Theme.of(context).colorScheme.secondary),
          TextButton(
            onPressed: () {
              dev.log(
                'lobbycode: $lobbyCode, players: ${players.join(', ')}',
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
