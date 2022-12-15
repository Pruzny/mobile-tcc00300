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
  final double menuMaxHeight = 300;
  final currency = NumberFormat.simpleCurrency(locale: "pt_BR");
  final _db = DatabaseHelper();
  User? _user;
  List<Advertisement> _advertisements = [];

  String? selectedState;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    getLogin();
  }
  

  @override
  Widget build(BuildContext context) {
    List<String> possibleStates = ["State"];
    possibleStates.addAll(states.keys);
    List<String> possibleCategories = ["Category"];
    possibleCategories.addAll(categories);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        centerTitle: true,
        backgroundColor: MyColors.mainColor,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: const Text("State"),
                  value: selectedState,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  menuMaxHeight: menuMaxHeight,
                  style: const TextStyle(color: MyColors.textColor),
                  underline: Container(
                    height: 2,
                    color: MyColors.borderColor,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedState = value != "State" ? value : null;
                      getAdvertisements(state: selectedState, category: selectedCategory);
                    });
                  },
                  items: possibleStates.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const Padding(padding: EdgeInsets.only(left: 40)),
                DropdownButton<String>(
                  hint: const Text("Category"),
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  menuMaxHeight: menuMaxHeight,
                  style: const TextStyle(color: MyColors.textColor),
                  underline: Container(
                    height: 2,
                    color: MyColors.borderColor,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value != "Category" ? value : null;
                      getAdvertisements(state: selectedState, category: selectedCategory);
                    });
                  },
                  items: possibleCategories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
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
              ),
            ),
          ]
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
    setState(() {});

    getAdvertisements();
  }

  getAdvertisements({String? state, String? category}) async {
    var res = await _db.getAdvertisementsExclude(user: _user);
    _advertisements.clear();
    for (var item in res) { 
      Advertisement advertisement = Advertisement.fromMap(item);
      bool matchState = state != null ? advertisement.state == state : true;
      bool matchCategory = category != null ? advertisement.category == category : true;
      if (matchState && matchCategory) {
        _advertisements.add(advertisement);
      }
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
