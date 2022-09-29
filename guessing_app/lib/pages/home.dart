import 'package:flutter/material.dart';
import 'package:guessing_app/pages/game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guessing App",
        style: Styles.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: Styles.mainBox,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home", style: Styles.normalText),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Game())
                );
              },
              child: const Text("Play", style: Styles.buttonText),
            )
          ]
        ),
      ),
    );
  }
}

class Styles {
  static const BoxDecoration mainBox = BoxDecoration(
    color: Colors.white,
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
}
