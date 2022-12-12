import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/helper/DatabaseHelper.dart';
import 'package:marketplace/model/Advertisement.dart';
import 'package:marketplace/model/User.dart';
import 'package:marketplace/pages/AdvertisementScreen.dart';
import 'package:marketplace/pages/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final VoidCallback signOut;
  const Home({super.key, required this.signOut});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currency = NumberFormat.simpleCurrency(locale: "pt_BR");
  final _db = DatabaseHelper();
  User? _user;
  List<Advertisement> _advertisements = [];

  @override
  void initState() {
    super.initState();
    getLogin();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'My advertisements', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: _advertisements.length,
          itemBuilder: (context, index) {
            final item = _advertisements[index];

            return InkWell(
              child: ListTile(
                title: Text(item.title!),
                subtitle: Text("${item.category} - ${currency.format(item.price)}"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvertisementScreen(advertisement: item))
                );
              },
            );
          }
        )
      ),
    );
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  getLogin() async {
    var sp = await SharedPreferences.getInstance();
    String name = sp.getString("user")!;
    var res = await _db.getUsers(name: name);
    _user = User.fromMap(res[0]);

    res = await _db.getAdvertisementsExclude(user: _user);
    _advertisements.clear();
    for (var item in res) {
      _advertisements.add(Advertisement.fromMap(item));
    }
    setState(() {});
  }

  void handleClick(String option) {
    switch (option) {
      case "Logout":
        signOut();
        break;
      case "My advertisements":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen())
        );
        break;
    }
  }
}
