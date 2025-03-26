import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('About WhatTheBomb'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'What is WhatTheBomb?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Text('''
WhatTheBomb is a drinking game inspired by the popular app Boomit. In this game, players have to pass the phone to each other, with a ticking time bomb on their nerves. The player that is currently holding the bomb gets a question, usually starting with "Who's most likely to ...". They have to pass the phone to the player that fits the description most accurately. At some point, the bomb will explode, resulting in a penalty for the player last holding the phone.

Boomit can only be played on one phone. The idea of WhatTheBomb is similar, except the game can be played on multiple phones at once. Players can connect to a server on their local network and create and join game lobbies. Games can then be played with everyone present in the lobby.

This app is a proof-of-concept for a school project and is in no way ready for production environments.

Made by Simon de Cock (Avans Hogeschool Breda)
'''),
          ],
        ),
      ),
    );
  }
}
