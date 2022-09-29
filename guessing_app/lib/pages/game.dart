import 'package:flutter/material.dart';
import 'home.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game",
        style: Styles.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: Styles.mainBox,
        width: double.infinity,
        height: double.infinity,
        child: const Center(child: SizedBox(
          width: 280,
          child: Text("Number", style: Styles.normalText),
        )),
      ),
    );
  }
}