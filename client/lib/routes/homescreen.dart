import 'package:flutter/material.dart';
import 'package:whatthebomb/routes/about.dart';
import 'package:whatthebomb/routes/creategame.dart';
import 'package:whatthebomb/routes/joingame.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'W H A T   T H E',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
            Text(
              'B  O  M  B',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinGame()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                minimumSize: Size(200, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text('Join game'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGame()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                minimumSize: Size(200, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text('Create game'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                minimumSize: Size(200, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
