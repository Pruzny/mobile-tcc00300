import 'package:covid19_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:covid19_tracker/pages/general.dart';

class Select extends StatefulWidget {
  const Select({super.key, required this.args});
  final Args args;

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? selectedItem;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title, style: Styles.title),
        centerTitle: true,
        backgroundColor: const Color(0xff4d3e6b),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xff81749c)),
        child: FutureBuilder(
          future: widget.args.getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> result = snapshot.data!;
              List<String> names = getNames(result);
              String? starter = widget.args.preItem;
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff4d3e6b),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Center(
                              child: Text(
                                "Select",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            selectedItemBuilder: (context) => names.map((item) => Align(alignment: Alignment.center, child: Text(item))).toList(),
                            items: names.map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                ).toList(),
                            value: selectedItem ?? starter,
                            onChanged: (String? item) {
                              setState(() {
                                selectedItem = item;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            dropdownColor: const Color(0xff4d3e6b),
                            underline: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xff81749c),
                              ),
                              height: 2,
                            ),
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: const Color(0xff81749c),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  selectedItem != null && result.isNotEmpty ? createItem(widget.args.labels, result.firstWhere((element) => element["country"] == selectedItem), 0) : const SizedBox(),
                ]
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            );
          },
        ),
      ),
    );
  }

  List<String> getNames(List<dynamic> data) {
    List<String> items = [];
    for (Map map in data) {
      items.add(map[widget.args.labels[0]]);
    }

    return items;
  }

  List<DropdownMenuItem<String>> createOptions(List<String> names) {
    List<DropdownMenuItem<String>> items = [];
    for (String name in names) {
      items.add(DropdownMenuItem(
        value: name,
        child: Text(name),
      ));
    }

    return items;
  }
}
