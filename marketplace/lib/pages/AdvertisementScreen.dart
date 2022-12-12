import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/model/Advertisement.dart';
import 'package:marketplace/pages/Profile.dart';

class AdvertisementScreen extends StatefulWidget {
  Advertisement advertisement;

  AdvertisementScreen({super.key, required this.advertisement});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final currency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  Widget build(BuildContext context) {
    Advertisement advertisement = widget.advertisement;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advertisement"),
        centerTitle: true,
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${currency.format(advertisement.price)} ",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  advertisement.title!,
                  style: const TextStyle(
                    fontSize: 26,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  advertisement.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                const Text(
                  "Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  states[advertisement.state]!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                const Text(
                  "Contact",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  advertisement.telephone!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: const Text("Copy contact"),  
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: advertisement.telephone));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact copied to clipboard!')),
              );
            },
          ),
        ),
      ),
    );
  }
}