import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Padding space = Padding(padding: EdgeInsets.only(top: 16));
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  Widget _result = Text(
    "Write your height and weight",
    style: Styles.resultText,
    textAlign: TextAlign.center,
  );

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
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  decoration: Styles.widgetBox,
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          decoration: Styles.inputBox,
                          padding: EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Weight",
                              labelStyle: Styles.labelText,
                              hintText: "Ex: 59.9",
                              hintStyle: Styles.placeholderText,
                              focusColor: Color.fromRGBO(255, 128, 48, 1),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                color: Color.fromRGBO(255, 128, 48, 1),
                                width: 2,
                              )),
                            ),
                            cursorColor: Color.fromRGBO(255, 128, 48, 1),
                            style: Styles.placeholderText,
                          )
                        ),
                      space,
                      Container(
                          decoration: Styles.inputBox,
                          padding: EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Height",
                              labelStyle: Styles.labelText,
                              hintText: "Ex: 1.68",
                              hintStyle: Styles.placeholderText,
                              focusColor: Color.fromRGBO(255, 128, 48, 1),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                color: Color.fromRGBO(255, 128, 48, 1),
                                width: 2,
                              )),
                            ),
                            cursorColor: Color.fromRGBO(255, 128, 48, 1),
                            style: Styles.placeholderText,
                          )
                        ),
                      space,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: calculateBmi,
                          style: Styles.calculateButton,
                          child: Text(
                            "Calculate",
                            style: Styles.calculateText,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              space,
              _result,
            ],
          )),
        ),
      ),
    );
  }
  void calculateBmi() {
    setState(() {
      String? weight = _weightController.text;
      String? height = _heightController.text;
      if (weight.isNotEmpty && height.isNotEmpty) {
        _result = Container(
          decoration: Styles.widgetBox,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text(
                "Your BMI is\n${(double.parse(weight)/pow(double.parse(height), 2)).toStringAsFixed(2)}",
                style: Styles.resultText,
                textAlign: TextAlign.center,
              ),
              space,
              ElevatedButton(
                onPressed: () {},
                style: Styles.shareButton,
                child: Text("Share"),
              ),
            ],
          )
        );
      }
    });
  }
}

class Styles {
  static const TextStyle appTitle = TextStyle(
    fontSize: 30,
    color: Color.fromRGBO(240, 114, 65, 1),
    fontWeight: FontWeight.bold,
  );
  static const TextStyle labelText = TextStyle(
    fontSize: 30,
    color: Colors.grey,
  );
  static const TextStyle placeholderText = TextStyle(
    fontSize: 20,
    color: Colors.grey,
  );
  static const BoxDecoration mainBox = BoxDecoration(
    color: Colors.black,
  );
  static BoxDecoration widgetBox = BoxDecoration(
    color: Color.fromRGBO(16, 16, 16, 1),
    borderRadius: BorderRadius.circular(30),
  );
  static BoxDecoration inputBox = BoxDecoration(
    color: Color.fromRGBO(32, 32, 32, 1),
    borderRadius: BorderRadius.circular(30),
  );
  static ButtonStyle calculateButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(192, 72, 72, 1)),
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 60)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
  );
  static ButtonStyle shareButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(192, 72, 72, 1)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
  );
  static TextStyle calculateText = TextStyle(
    color: Colors.white,
    fontSize: 32,
  );
  static TextStyle resultText = TextStyle(
    color: Colors.white,
    fontSize: 32,
  );
}