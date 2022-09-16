import 'package:flutter/material.dart';

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
  String _myOption = "default";
  var _compOption = "default";

  @override
  Widget build(BuildContext context) {
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
                      Image.asset("images/$_compOption.png", height: 160),
                    ]
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Your option:", style: Styles.label),
                      Image.asset("images/$_myOption.png", height: 160),
                    ]
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: createButtons(),
                  ),
                ),
              ],
            ),
          )
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
                  _myOption = option.toLowerCase();
                  _compOption = options[(options.indexOf(option) + 1) % 3].toLowerCase();
                });
              },
              style: Styles.button,
              child: Text(option, style: Styles.option),
            )
          ],
        )
      );
    }

    return buttons;
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
    color: Color.fromRGBO(247, 240, 176, 160),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  static const TextStyle title = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
  static const TextStyle label = TextStyle(
    fontSize: 28,
  );
  static const TextStyle option = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
  static ButtonStyle button = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 230, 0)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    minimumSize: MaterialStateProperty.all(Size(110, 36)),
  );
}