import 'dart:math';

import 'package:flutter/material.dart';
import 'home.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.args});

  final GameArguments args;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _count = 0;
  int _backgroundHex = 0xfff6f6f6;
  int _guess = 0;
  bool _hasWon = false;
  String _text = "";
  bool _boldText = false;
  int _score = 1000;
  final TextEditingController _inputNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int totalChances = widget.args.difficulty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game",
        style: Styles.title),
        centerTitle: true,
        backgroundColor: const Color(0xff1f192f),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(_backgroundHex)),
        width: double.infinity,
        height: double.infinity,
        child: Center(child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 300,
                height: 60,
                child: Container(
                  decoration: GameStyles.widgetBox,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        !_hasWon ? "Chances:" : "Score:",
                        style: GameStyles.labelText,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        !_hasWon ? "${totalChances - _count}/$totalChances" : "$_score",
                        style: Styles.normalText
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
          Center(
            child: Container(
              decoration: GameStyles.widgetBox,
              width: 300,
              height: 280,
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _inputNum,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Number",
                      labelStyle: GameStyles.labelText,
                      hintText: "0-100",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 100),
                        fontSize: 20,
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 24,
                      ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  Container(
                    decoration: GameStyles.background,
                    alignment: Alignment.center,
                    child: MaterialButton(
                      color: const Color(0xff2d6073),
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        if (int.tryParse(_inputNum.text) != null && !_hasWon) {
                          int num = int.parse(_inputNum.text);
                          if (0 <= num && num <= 100) {
                            setState(() {
                              _count++;
                              _guess = num;
                              setBackgroundHex();
                            });
                          }
                        }
                      },
                      child: Text(
                        "Guess",
                        style: GameStyles.buttonText,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(6)),
                  Text(
                    _text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: _boldText ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])),
      ),
    );
  }

  void setBackgroundHex() {
    int dif = _guess - widget.args.number;
    int absDif = dif.abs();

    if (absDif == 0) {
      _backgroundHex = 0x88209cee;
      _hasWon = true;
      _text = "Congratulations!\nThe number is ${widget.args.number}";
      _boldText = true;
    } else {
      _score -= ((_guess - widget.args.number).abs() / 2).round();

      if (absDif < 10) {
        _backgroundHex = 0x8823d160;
      } else if (absDif < 20) {
        _backgroundHex = 0x88ffdd57;
      } else {
        _backgroundHex = 0x88ff3860;
      }

      if (dif < 0) {
        _text = "Tip: higher";
      } else if (dif > 0) {
        _text = "Tip: lower";
      }
    }
  }
}

class GameArguments {
  final int difficulty;
  final int number;

  const GameArguments(this.difficulty, this.number);
}

class GameStyles {
  static BoxDecoration background = const BoxDecoration(
    color: Colors.blueAccent,
  );
  static TextStyle inputStyle = const TextStyle(
    fontSize: 26,
  );
  static TextStyle buttonText = const TextStyle(
    color: Colors.white,
    fontSize: 24,
  );
  static BoxDecoration widgetBox = BoxDecoration(
    color: const Color(0xfff6f6f6),
    borderRadius: BorderRadius.circular(20),
  );
  static TextStyle labelText = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
}

// #5e0324
// #692764
// #7b7893
// #7fb1a8
// #94f9bf



// #1f192f
// #2d6073
// #65b8a6
// #b5e8c3
// #f0f7da
