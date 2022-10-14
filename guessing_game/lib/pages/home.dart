import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guessing_game/pages/game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _difficulty = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Guessing Game",
          style: Styles.title
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1f192f),
      ),
      body: Container(
        decoration: Styles.mainBox,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Column(children: [
                createTile("Easy", 20),
                createTile("Normal", 15),
                createTile("Hard", 6),
                const Padding(padding: EdgeInsets.all(4)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Game(args: GameArguments(_difficulty!, Random().nextInt(100))))
                    );
                  },
                  style: Styles.buttonStyle,
                  child: const Text("Play", style: Styles.buttonText),
                ),
              ],)
            ),
            
          ]
        ),
      ),
    );
  }

  RadioListTile createTile(String label, int chances) {
    return RadioListTile(
      title: Text(
        label,
        style: Styles.optionText,
      ),
      subtitle: Text("$chances chances"),
      value: chances,
      groupValue: _difficulty,
      onChanged: (value) {
        setState(() {
          _difficulty = value;
        });
      }
    );
  }
}

class Styles {
  static const BoxDecoration mainBox = BoxDecoration(
    color: Color(0xfff6f6f6),
  );
  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 32,
  );
  static const TextStyle normalText = TextStyle(
    color: Colors.black54,
    fontSize: 32,
  );
  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 24,
  );
  static const TextStyle optionText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  static ButtonStyle buttonStyle = ButtonStyle(
    alignment: Alignment.center,
    backgroundColor: MaterialStateProperty.all(const Color(0xff2d6073)),
    minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
    maximumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
  );
}
