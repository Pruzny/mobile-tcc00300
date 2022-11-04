import 'package:covid19_tracker/pages/home.dart';
import 'package:flutter/material.dart';

class Brazil extends StatefulWidget {
  const Brazil({super.key, required this.args});
  final Args args;

  @override
  State<Brazil> createState() => _BrazilState();
}

class _BrazilState extends State<Brazil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title, style: Styles.title),
        centerTitle: true,
        backgroundColor: const Color(0xff4d3e6b),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff81749c)),
      ),
    );
  }
}