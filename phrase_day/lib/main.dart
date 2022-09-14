import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Phrase of the Day",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(actions: const [

          ],
          title: Text("Phrase of the Day"),
        ),
        body: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: Styles.mainBox,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: Styles.textBox,
                    child: Text(
                        textAlign: TextAlign.justify,
                        phrase,
                        style: Styles.mainText,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      spacing: 6,
                      direction: Axis.vertical,
                      children: createButtons()
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createButtons() {
    List<Widget> buttons = [];
    for (String day in phraseList.keys) {
      buttons.add(ElevatedButton(
        onPressed: () => changeText(phraseList[day]!),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(20, 20, 20, 64)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          minimumSize: MaterialStateProperty.all(Size(256, 0)),
        ),
        child: Text(day, style: Styles.buttonText),
      ));
    }
    
    return buttons;
  }
  
  String phrase = "Press a button";

  void changeText(String newText) {
    setState(() {
      phrase = newText;
    });
  }
}

class Styles {
  static BoxDecoration mainBox = BoxDecoration(
    color: Colors.lightBlueAccent,
  );
  static const TextStyle mainText = TextStyle(
    fontSize: 24,
    color: Colors.black,
    decoration: TextDecoration.none,
  );
  static const BoxConstraints textBox = BoxConstraints(
    minHeight: 160,
    maxHeight: 160,
    minWidth: 300,
    maxWidth: 300,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 42,
    color: Colors.white70,
    decoration: TextDecoration.none,
  );
}

class DayButton extends ElevatedButton {
  DayButton(String text, {void Function(String)? function, super.key}) :
    super(
      onPressed: () => function!(text),
      child: Text(text, style: Styles.buttonText),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(20, 20, 20, 64))),
    );
}

const phraseList = {
  "Sunday": "If you just focus on the smallest details, you never get the big picture right.",
  "Monday": "However difficult life may seem, there is always something you can do and succeed at.",
  "Tuesday": "Sure, good things can go badly wrong. Nevertheless, there's always another day.",
  "Wednesday": "This is a new day which gives you the chance to try different things.",
  "Thursday": "A good day is a good day. A bad day is a good story.",
  "Friday": "Success is a journey, not a destination.",
  "Saturday": "May you be blessed with lots of compassion and opportunities as you start your new day.",
};

