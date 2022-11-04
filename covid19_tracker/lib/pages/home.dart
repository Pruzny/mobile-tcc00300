import 'package:covid19_tracker/pages/general.dart';
import 'package:covid19_tracker/pages/brazil.dart';
import 'package:covid19_tracker/pages/select.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
          'COVID-19 Tracker',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => General(args: Args(
                      title: 'General',
                      url: 'https://covid19-brazil-api.now.sh/api/report/v1/countries',
                      labels: [
                        'country',
                        'confirmed',
                        'deaths'
                      ],
                    )))
                  );
                },
                style: Styles.itemButton,
                child: const Text(
                  'General',
                  style: Styles.itemText,
                )
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Brazil())
                  );
                },
                style: Styles.itemButton,
                child: const Text(
                  'Brazil',
                  style: Styles.itemText,
                )
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Select(args: Args(
                      title: 'Country',
                      url: 'https://covid19-brazil-api.vercel.app/api/report/v1/countries',
                      labels: [
                        'country',
                        'confirmed',
                        'deaths'
                      ],
                    )))
                  );
                },
                style: Styles.itemButton,
                child: const Text(
                  'Country',
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
    fontSize: 38,
    fontWeight: FontWeight.bold
  );
  static BoxDecoration itemBox = BoxDecoration(
    color: Colors.black54,
    borderRadius: BorderRadius.circular(10),
  );
  static const TextStyle itemText = TextStyle(
    color: Colors.white,
    fontSize: 40,
  );
  static const itemButton = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.black54),
    minimumSize: MaterialStatePropertyAll(Size(200, 60)),
  );
}

class Args {
  final String title;
  final String url;
  final List<String> labels;
  String? preItem;

  Args({required this.title, required this.url, required this.labels, this.preItem});

  Future<List<dynamic>> getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode.toString() == '200') {
      return json.decode(response.body)['data'];
    }

    return List.empty();
  }

  static String capitalize(String str) {
    return str.isNotEmpty ? str[0].toUpperCase() + str.substring(1) : "";
  }
}

// #81749c
// #4d3e6b
// #8daec3
// #c5dfe0
// #fcfce2