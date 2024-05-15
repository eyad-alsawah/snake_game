import 'package:flutter/material.dart';
import 'package:snake_game/presentation/views/game_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameView(
        screenWidth: MediaQuery.sizeOf(context).width,
        screenHeight: MediaQuery.sizeOf(context).height - 20,
        numberOfSquaresHorizontally: 20,
      ),
    );
  }
}
