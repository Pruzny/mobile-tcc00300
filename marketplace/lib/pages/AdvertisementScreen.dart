import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/model/Advertisement.dart';
import 'package:marketplace/pages/Profile.dart';

class AdvertisementScreen extends StatefulWidget {
  final Advertisement advertisement;

  const AdvertisementScreen({super.key, required this.advertisement});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final currency = NumberFormat.simpleCurrency(locale: "pt_BR");
  final double imageSize = 240;

  @override
  Widget build(BuildContext context) {
    Advertisement advertisement = widget.advertisement;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Advertisement",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: MyColors.mainColor,
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
                Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: advertisement.photo == null ? const Text(
                      "No image",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ) : Image.memory(
                      base64Decode(advertisement.photo),
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${currency.format(advertisement.price)} ",
                    style: const TextStyle(
                      fontSize: 28,
                      color: MyColors.textColor,
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.buttonColor,
        foregroundColor: Colors.white,
        label: const Text("Copy contact"),  
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: advertisement.telephone));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact copied to clipboard!')),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MyColors {
  static const mainColor = Color(0xff320139);
  static const buttonColor = Color(0xff4d1d4d);
  static const textColor = Color(0xff5f0d3b);
  static const borderColor = Color(0xff413b6b);
  static const trackColor = Color(0xff985277);
  static const thumbColor = Color(0xff5c374c);
}