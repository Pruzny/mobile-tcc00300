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
  String _text = "Calo";
  var _compOption = "default";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rock-Paper-Scissors",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: const [],
          title: Text("Rock-Paper-Scissors")
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text("Computer's option:", style: Styles.label),
                    Image.asset("images/$_compOption.png", height: 160),
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
    );
  }

  List<Widget> createButtons() {
    List<Widget> buttons = [];
    for (String option in options) {
      buttons.add(
        Column(
          children: [
            Image.asset("images/${option.toLowerCase()}.png", height: 120),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _text = option;
                  _compOption = option.toLowerCase();
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
  static const BoxDecoration mainBox = BoxDecoration(
    
  );
  static const TextStyle label = TextStyle(
    fontSize: 30,
  );
  static const TextStyle option = TextStyle(
    fontSize: 20,
  );
  static ButtonStyle button = ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    minimumSize: MaterialStateProperty.all(Size(120, 36)),
  );
}