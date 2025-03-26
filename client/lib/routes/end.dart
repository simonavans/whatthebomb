import 'package:flutter/material.dart';
import 'package:whatthebomb/routes/homescreen.dart';

class End extends StatelessWidget {
  const End({super.key, required this.loser, required this.penalty});

  final String loser;
  final String penalty;

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
            const SizedBox(height: 300),
            const Text('B O O M !', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 60),
            Text('${loser.toUpperCase()} HAD AN EXPLOSIVE TREAT!'),
            Card(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[Text('Penalty: $penalty')]),
              ),
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('To homescreen'),
            ),
          ],
        ),
      ),
    );
  }
}
