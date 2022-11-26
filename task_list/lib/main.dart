import 'package:flutter/material.dart';

import 'pages/Home.dart';

void main() {
  runApp(const MaterialApp(
    title: "Task List",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}