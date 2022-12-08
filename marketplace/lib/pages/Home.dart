import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  final VoidCallback signOut;
  const Home({super.key, required this.signOut});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      
      body: Container(
        alignment: Alignment.center,
        child: const Text("Home"),
      ),
    );
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }
}