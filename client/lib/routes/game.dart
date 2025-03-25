import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({
    super.key,
    required this.players,
    required this.playerName,
    required this.seed,
  });

  final List<String> players;
  final String playerName;
  final int seed;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final scrollController = ScrollController();
  String question = '';
  bool holdsBomb = false;

  @override
  void initState() {
    int playerIndex = super.widget.players.indexOf(super.widget.playerName);
    assert(
      playerIndex != -1,
      "Player ${super.widget.playerName} not found in players",
    );

    setState(() {
      question = (super.widget.seed % 8).toString();
      holdsBomb =
          (super.widget.seed % super.widget.players.length) == playerIndex;
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
            Text('BOMB HOLDER TEXT'),
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
                            onPressed: () {
                              dev.log(
                                '${super.widget.players[index]} selected',
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
