import 'package:covid19_tracker/pages/home.dart';
import 'package:covid19_tracker/pages/general.dart';
import 'package:covid19_tracker/pages/select.dart';
import 'package:flutter/material.dart';

class Brazil extends StatefulWidget {
  const Brazil({super.key});

  @override
  State<Brazil> createState() => _BrazilState();
}

class _BrazilState extends State<Brazil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brazil", style: Styles.title),
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
                onPressed: () {},
                style: Styles.itemButton,
                child: const Text(
                  'Date',
                  style: Styles.itemText,
                )
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => General(args: Args(
                      title: 'States',
                      url: 'https://covid19-brazil-api.now.sh/api/report/v1',
                      labels: [
                        'state',
                        'cases',
                        'deaths',
                        'suspects',
                        'refuses',
                      ],
                    )))
                  );
                },
                style: Styles.itemButton,
                child: const Text(
                  'States',
                  style: Styles.itemText,
                )
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Select(args: Args(
                      title: 'State',
                      url: 'https://covid19-brazil-api.vercel.app/api/report/v1',
                      labels: [
                        'state',
                        'cases',
                        'deaths'
                        'suspects',
                        'refuses',
                      ],
                    )))
                  );
                },
                style: Styles.itemButton,
                child: const Text(
                  'State',
                  style: Styles.itemText,
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}