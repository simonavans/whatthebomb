import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatthebomb/routes/homescreen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final List<String> questions = [];
final List<String> penalties = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getGameTextsFromFile();
  runApp(const MainApp());
}

Future<void> getGameTextsFromFile() async {
  final String rawJson = await rootBundle.loadString('assets/gameTexts.json');
  final data = await json.decode(rawJson);

  for (String question in data["questions"]) {
    questions.add(question);
  }

  for (String penalty in data["penalties"]) {
    penalties.add(penalty);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: HomeScreen(),
    );
  }
}
