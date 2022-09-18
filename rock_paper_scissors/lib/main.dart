import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _playerOption = "Default";
  var _compOption = "Default";
  Widget? _resultBackground;
  String _resultText = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: "Rock-Paper-Scissors",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: const [],
          title: Text("Rock-Paper-Scissors", style: Styles.title),
          backgroundColor: Color.fromARGB(255, 255, 230, 0),
          centerTitle: true,
        ),
        body: Container(
          decoration: Styles.border,
          child: Container(
            decoration: Styles.mainBox,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Enemy's option:", style: Styles.label),
                      Image.asset("images/${_compOption.toLowerCase()}.png", height: 120),
                    ]
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Your option:", style: Styles.label),
                      Image.asset("images/${_playerOption.toLowerCase()}.png", height: 120),
                    ]
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: createButtons(),
                    ),
                    Container(child: _resultBackground)
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createButtons() {
    List<Widget> buttons = [];
    for (String option in options) {
      buttons.add(
        Column(
          children: [
            Image.asset("images/${option.toLowerCase()}.png", height: 110),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _playerOption = option;
                });
                setCompOption();
                setResult();
              },
              style: Styles.optionButton,
              child: Text(option, style: Styles.optionText),
            )
          ],
        )
      );
    }

    return buttons;
  }

  void setCompOption() {
    _compOption = options[Random().nextInt(3)];
  }

  void setResult() {
    calculateResult();
    setState(() {
      _resultBackground = Container(
        width: 400,
        height: 160,
        decoration: BoxDecoration(color: Color.fromARGB(255, 253, 249, 211)),
        child: createResultBox(),
      );
    });
  }

  void calculateResult() {
    int compIndex = options.indexOf(_compOption);
    int playerIndex = options.indexOf(_playerOption);
    String text = "";
    if (compIndex == playerIndex) {
      text = "Draw";
    } else if (compIndex == playerIndex + 1 % 3) {
      text = "You lose";
    } else {
      text = "You win";
    }
    setState(() {
      _resultText = text;
    });
  }

  void reset() {
    setState(() {
      _resultBackground = null;
        _playerOption = "default";
      _compOption = "default";
    });
  }

  Center createResultBox() {
    return Center(
      child: Container(
        decoration: Styles.resultBox,
        width: 200,
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_resultText, style: Styles.resultText),
            ElevatedButton(
              onPressed: reset,
              style: Styles.resetButton,
              child: Text("Play Again", style: Styles.resetText)
            ),
          ]
        ),
      ),
    );
  }
}

const options = [
  "Rock",
  "Paper",
  "Scissors",
];

class Styles {
  static BoxDecoration border = BoxDecoration(
    border: Border.all(width: 10, color: Colors.white),
    color: Colors.white,
  );
  static const BoxDecoration mainBox = BoxDecoration(
    color: Color.fromARGB(255, 253, 249, 211),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  static  BoxDecoration resultBox = BoxDecoration(
    color: Color.fromARGB(255, 88, 88, 88),
    borderRadius: BorderRadius.circular(16)
  );
  static const TextStyle title = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
  static const TextStyle label = TextStyle(
    fontSize: 28,
  );
  static const TextStyle optionText = TextStyle(
    fontSize: 18,
    color: Colors.black,
  );
  static const TextStyle resultText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle resetText = TextStyle(
    fontSize: 16,
  );
  static ButtonStyle optionButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 230, 0)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    minimumSize: MaterialStateProperty.all(Size(110, 36)),
  );
  static ButtonStyle resetButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 201, 66, 57)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
  );
}