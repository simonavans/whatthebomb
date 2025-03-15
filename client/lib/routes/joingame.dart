import 'package:flutter/material.dart';
import 'package:whatthebomb/routes/lobby.dart';

class JoinGame extends StatelessWidget {
  const JoinGame({super.key});

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
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '00000',
            ),
          ),
          const Text('My name'),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Player 1',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lobby()),
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
