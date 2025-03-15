import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('W H A T   T H E', textAlign: TextAlign.center),
            Text(
              'B  O  M  B',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 60),
            Text('BOMB HOLDER TEXT'),
            Card(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text('Most likely to leave a café and forgetting to pay?'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
