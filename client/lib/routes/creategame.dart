import 'package:flutter/material.dart';
import 'package:whatthebomb/routes/lobby.dart';

class CreateGame extends StatelessWidget {
  const CreateGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create game'),
      ),
      body: Column(
        children: <Widget>[
          const Text('My name'),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Player 1',
            ),
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
            child: Text('Create game'),
          ),
        ],
      ),
    );
  }
}
