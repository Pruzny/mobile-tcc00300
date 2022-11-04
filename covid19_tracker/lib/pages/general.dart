import 'package:covid19_tracker/pages/home.dart';
import 'package:covid19_tracker/pages/select.dart';
import 'package:flutter/material.dart';

class General extends StatefulWidget {
  const General({super.key, required this.args});
  final Args args;

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
                'Loading',
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
            child: ListView(
              children: snapshot.data!
            ),
          );
        } else if (snapshot.hasError) {
          mainScreen = Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xff81749c)),
            child: const Text(
              'Error',
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
            title: Text(widget.args.title, style: Styles.title),
            centerTitle: true,
            backgroundColor: const Color(0xff4d3e6b),
          ),
          body: mainScreen,
        );
      }
    );
  }

  Future<List<Widget>> createItems() async {
    Future<List<dynamic>> result = widget.args.getData();
    Container divider = Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: 2,
    );
    List<Widget> items = [divider];
    int count = 0;
    for (Map<String, dynamic> map in await result) {
      items.add(
        InkWell(
          onTap: () {
            widget.args.preItem = map[widget.args.labels[0]];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Select(args: widget.args)),
            );
          },
          child: IntrinsicHeight(child: createItem(widget.args.labels, map, count)),
        )
      );
      items.add(divider);
      count++;
    }

    return items;
  }
}

Container createItem(List<String> labels, Map<String, dynamic> data, int count) {
  List<Widget> texts = [Text(
      data[labels[0]],
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),];

    for (String label in labels.sublist(1)) {
      texts.add(Row(
        children: [
          Text(
            '${Args.capitalize(label)}: ',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '${data[label] ?? 'undefined'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
      ));
    }
    return Container(
      decoration: BoxDecoration(color: count % 2 == 1 ? const Color.fromARGB(255, 163, 196, 204) : const Color(0xffc5dfe0)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: texts,
      ),
    );
}