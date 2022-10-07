import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const double widgetWidth = 200.0;
  static const Padding space = Padding(padding: EdgeInsets.only(top: 16));
  double _weight = 0;
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BMI Calculator",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: const [],
          backgroundColor: Color.fromRGBO(32, 32, 32, 1),
          title: const Text(
            "BMI Calculator",
            style: Styles.appTitle,
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: Styles.mainBox,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: Styles.inputBox,
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Weight",
                    labelStyle: Styles.placeholderText,
                  ),
                  style: Styles.placeholderText,
                )
              ),
              space,
              Container(
                decoration: Styles.inputBox,
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Height",
                    labelStyle: Styles.placeholderText,
                  ),
                  style: Styles.placeholderText,
                )
              ),
              space,
              SizedBox(
                width: widgetWidth,
                child: ElevatedButton(
                  onPressed: calculateBmi,
                  style: Styles.calculateButton,
                  child: Text(
                    "Calculate",
                    style: Styles.calculateText,
                  )),
              )
            ],
          )),
        ),
      ),
    );
  }

  void calculateBmi() {

  }
}

class Styles {
  static const TextStyle appTitle = TextStyle(
    fontSize: 30,
    color: Colors.purpleAccent,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle placeholderText = TextStyle(
    fontSize: 30,
    color: Colors.grey,
  );
  static const BoxDecoration mainBox = BoxDecoration(
    color: Colors.black,
  );
  static BoxDecoration inputBox = BoxDecoration(
    color: Color.fromRGBO(32, 32, 32, 1),
    borderRadius: BorderRadius.circular(30),
  );
  static ButtonStyle calculateButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
  );
  static TextStyle calculateText = TextStyle(
    color: Colors.white,
    fontSize: 32,
  );
}