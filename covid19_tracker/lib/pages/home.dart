import 'package:flutter/material.dart';


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
        title: const Text(
          "COVID-19 Tracker",
          style: Styles.title,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff4d3e6b),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff81749c)),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: Styles.itemBox,
                child: const Text(
                  "Home",
                  style: Styles.itemText,
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}

class Styles {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold
  );
  static BoxDecoration itemBox = BoxDecoration(
    color: Colors.black54,
    borderRadius: BorderRadius.circular(10),
  );
  static const TextStyle itemText = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

// #81749c
// #4d3e6b
// #8daec3
// #c5dfe0
// #fcfce2