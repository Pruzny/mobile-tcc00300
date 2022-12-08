import 'dart:convert';

class User {

  int? id;
  String name;
  String? email;
  String password;

  User({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": this.id,
      "name": this.name,
      "email": this.email,
      "password": this.password ,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"] ??= map["id"],
      name: map["name"] as String,
      email: map["email"] as String,
      password: map["password"] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
