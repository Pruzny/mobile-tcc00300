import 'dart:ffi';

import 'package:covid19_tracker/pages/home.dart';
import 'package:flutter/material.dart';

class General extends StatefulWidget {
  const General({super.key, required this.result});
  final Future<List<dynamic>> result;

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: createItems(),
      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
        Widget mainScreen = Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xff81749c)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Loading",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ]
          ),
        );

        if (snapshot.hasData) {
          mainScreen = Container(
            decoration: const BoxDecoration(color: Color(0xff81749c)),
            child: SingleChildScrollView(
              child: Column(
                children: snapshot.data!
              ),
            ),
          );
        } else if (snapshot.hasError) {
          mainScreen = Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xff81749c)),
            child: const Text(
              "Error",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('General', style: Styles.title),
            centerTitle: true,
            backgroundColor: const Color(0xff4d3e6b),
          ),
          body: mainScreen,
        );
      }
    );
  }

  Future<List<Widget>> createItems() async {
    Future<List<dynamic>> result = widget.result;
    Container divider = Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: 2,
    );
    List<Widget> items = [divider];
    int count = 0;
    for (Map<String, dynamic> map in await result) {
      items.add(
        Container(
          decoration: BoxDecoration(color: count % 2 == 1 ? const Color.fromARGB(255, 163, 196, 204) : const Color(0xffc5dfe0)),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                map['country'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Confirmed: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${map['confirmed'] ?? 'undefined'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
              Row(
                children: [
                  const Text(
                    'Deaths: ',
                    style: TextStyle(
                      fontSize: 18),
                  ),
                  Text(
                    '${map['deaths'] ?? 'undefined'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            ]
          ),
        )
      );
      items.add(divider);
      count++;
    }

    return items;
  }
}