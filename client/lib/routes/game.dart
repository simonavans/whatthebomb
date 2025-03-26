import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatthebomb/main.dart';
import 'package:whatthebomb/routes/end.dart';

class Game extends StatefulWidget {
  const Game({
    super.key,
    required this.connection,
    required this.players,
    required this.playerName,
    required this.seed,
  });

  final HubConnection connection;
  final List<String> players;
  final String playerName;
  final int seed;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final scrollController = ScrollController();
  late int questionSeed;

  String question = '';
  bool holdsBomb = false;
  String bombHolder = '';

  String nextQuestion() {
    final random = Random(questionSeed);
    questionSeed = random.nextInt(2 ^ 32);
    return questions[questionSeed % questions.length];
  }

  @override
  void initState() {
    questionSeed = super.widget.seed;

    super.widget.players.sort();
    int playerIndex = super.widget.players.indexOf(super.widget.playerName);
    assert(
      playerIndex != -1,
      "Player ${super.widget.playerName} not found in players",
    );
    int chosenPlrIndex = super.widget.seed % super.widget.players.length;

    setState(() {
      question = nextQuestion();
      bombHolder = super.widget.players[chosenPlrIndex];
      holdsBomb = chosenPlrIndex == playerIndex;
    });

    super.widget.connection.on('passbombevent', (msg) {
      if (msg == null || msg.length < 2) {
        dev.log("msg was invalid", name: '$Game');
        return;
      }

      setState(() {
        holdsBomb = msg[1] == super.widget.playerName;
        question = nextQuestion();
        bombHolder = msg[1];
      });
    });

    Future.delayed(Duration(seconds: (super.widget.seed % 10) + 15), () {
      String penalty = penalties[super.widget.seed % penalties.length];
      super.widget.connection.stop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => End(loser: bombHolder, penalty: penalty),
        ),
      );
    });

    super.initState();
  }

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
            Text('${bombHolder.toUpperCase()} IS HOLDING THE BOMB'),
            Card(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[Text(question)]),
              ),
            ),
            holdsBomb
                ? ListView.builder(
                  controller: scrollController,
                  itemCount: super.widget.players.length,
                  shrinkWrap: true,
                  itemBuilder:
                      (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () async {
                              await super.widget.connection.invoke(
                                "passbombrequest",
                                args: [
                                  super.widget.playerName,
                                  super.widget.players[index],
                                ],
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: Text(super.widget.players[index]),
                          ),
                        ),
                      ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
