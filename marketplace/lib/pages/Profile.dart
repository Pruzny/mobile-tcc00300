import 'package:flutter/material.dart';
import 'package:marketplace/helper/DatabaseHelper.dart';
import 'package:marketplace/model/Advertisement.dart';
import 'package:marketplace/model/User.dart';
import 'package:marketplace/pages/AdvertisementScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db = DatabaseHelper();
  User? _user;
  List<Advertisement> _advertisements = [];

  String selectedState = states.keys.first;
  String selectedCategory = categories.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My advertisements"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: _advertisements.length,
          itemBuilder: (context, index) {
            final item = _advertisements[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvertisementScreen(advertisement: item))
                );
              },
              child: ListTile(
                title: Text(item.title!),
                subtitle: Text("${item.category} - ${item.price}"),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete advertisement?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: const Text("Cancel")
                            ),
                            TextButton(
                              onPressed: () {
                                _removeAdvertisement(item.id);
                                Navigator.pop(context);
                              }, 
                              child: const Text("Delete")
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Icon(
                      Icons.remove_circle,
                      color: Color(0xffcc0c39),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1693a7),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),  
        onPressed: () => _showAddScreen()
      ),
    );
  }

  getLogin() async {
    var sp = await SharedPreferences.getInstance();
    String name = sp.getString("user")!;
    var res = await _db.getUsers(name: name);
    _user = User.fromMap(res[0]);
    setState(() {});

    getAdvertisements();
  }

  getAdvertisements() async {
    var res = await _db.getAdvertisementsFrom(user: _user);
    _advertisements.clear();
    for (var item in res) {
      _advertisements.add(Advertisement.fromMap(item));
    }
    setState(() {});
  }

  void _showAddScreen({Advertisement? advertisement}) {
    String saveUpdateText = "";

    if (advertisement == null) {
      titleController.text = "";
      descriptionController.text = "";
      saveUpdateText = "Create";
    } else {
      titleController.text = advertisement.title!;
      descriptionController.text = advertisement.description!;
      saveUpdateText = "Update";
    }

    showDialog(
      context: context, 
      builder: (context) {

        return StatefulBuilder(
          builder:(context, setState) {
            return AlertDialog(
              title: Text(saveUpdateText),
              
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedState,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.blue),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedState = value!;
                        });
                      },
                      items: states.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.blue),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        hintText: "Ex: smartphone"
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Price",
                        hintText: "Ex: 500"
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: telephoneController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        hintText: "Ex: 21987654321"
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: descriptionController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Ex: 64gb"
                      ),
                    ),
                  ]
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: () {
                    String price = priceController.text;
                    String phone = telephoneController.text;
                    if (titleController.text != "" && descriptionController.text != "" && price != "" && phone != "") {
                      if (validatePhone(phone)) {
                        double? value = double.tryParse(price);
                        if (value != null && value > 0) {
                          _insertUpdateAdvertisement(selectedAdvertisement: advertisement);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid price!')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid phone!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields. ')),
                      );
                    }
                  }, 
                  child: Text(saveUpdateText)
                ),
              ],
            );
          },
        );
      }
    );
  }

  bool validatePhone(String phone) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (phone.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(phone)) {
      return false;
    }
    return true;
  } 

  void _insertUpdateAdvertisement({Advertisement? selectedAdvertisement}) async{

    String title = titleController.text;
    double? price = double.tryParse(priceController.text);
    String telephone = telephoneController.text;
    String description = descriptionController.text;

    if (selectedAdvertisement == null) {
      if (price != null) {
        Advertisement advertisement = Advertisement(
          state: selectedState,
          category: selectedCategory,
          title: title,
          price: price,
          telephone: telephone,
          description: description,
          user: _user!.id,
        );
        int result = await _db.insertAdvertisement(advertisement);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid price!')),
        );
      }
    } else {
      selectedAdvertisement.state = selectedState;
      selectedAdvertisement.category = selectedCategory;
      selectedAdvertisement.title = title;
      selectedAdvertisement.price = price;
      selectedAdvertisement.telephone = telephone;
      selectedAdvertisement.description = description;

      int result = await _db.updateAdvertisement(selectedAdvertisement);
    }

    selectedState = states.keys.first;
    selectedCategory = categories.first;
    titleController.clear();
    priceController.clear();
    telephoneController.clear();
    descriptionController.clear();

    getAdvertisements();
  }

  _removeAdvertisement(int? id) async {
    await _db.deleteAdvertisement(id!);

    getAdvertisements();
  }
}

const Map<String, String> states = {
    'AC': 'Acre',
    'AL': 'Alagoas',
    'AP': 'Amapá',
    'AM': 'Amazonas',
    'BA': 'Bahia',
    'CE': 'Ceará',
    'DF': 'Distrito Federal',
    'ES': 'Espírito Santo',
    'GO': 'Goiás',
    'MA': 'Maranhão',
    'MT': 'Mato Grosso',
    'MS': 'Mato Grosso do Sul',
    'MG': 'Minas Gerais',
    'PA': 'Pará',
    'PB': 'Paraíba',
    'PR': 'Paraná',
    'PE': 'Pernambuco',
    'PI': 'Piauí',
    'RJ': 'Rio de Janeiro',
    'RN': 'Rio Grande do Norte',
    'RS': 'Rio Grande do Sul',
    'RO': 'Rondônia',
    'RR': 'Roraima',
    'SC': 'Santa Catarina',
    'SP': 'São Paulo',
    'SE': 'Sergipe',
    'TO': 'Tocantins'
};

const Set<String> categories = {
  "Clothing",
  "Electronic",
  "Housing",
  "Other",
  "Vehicles",
};
