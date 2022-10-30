import 'package:covid19_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Country extends StatefulWidget {
  const Country({super.key, required this.result});
  final Future<List<dynamic>> result;

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country", style: Styles.title),
        centerTitle: true,
        backgroundColor: const Color(0xff4d3e6b),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff81749c)),
      ),
    );
  }
}