import 'package:flutter/material.dart';
import 'package:marketplace/helper/DatabaseHelper.dart';
import 'package:marketplace/pages/AdvertisementScreen.dart';
import 'package:marketplace/pages/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

enum LoginStatus { notSignIn, signIn }

class Login extends StatefulWidget {  
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? _username, _email, _password;
  final _formKey = GlobalKey<FormState>();
  late DatabaseHelper controller;
  var value;
  bool signUp = false;

  _LoginState() {
    this.controller = DatabaseHelper();
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {      
      form.save();

      try{
        User? user;
        if (signUp) {
          if ((await controller.getUsers(name: _username)).isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User already registered!')),
            );
          } else if ((await controller.getUsers(email: _email)).isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email already registered!')),
            );
          } else {
            user = User(
              name: _username!,
              email: _email!,
              password: _password!,
            );
            controller.insertUser(user);
          }
        } else {
          user = await controller.getLogin(_username!, _password!);
        }
        if (user != null) {
          savePref(1, user.name, user.password);
          _loginStatus = LoginStatus.signIn;
        } else if (!signUp) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid user!')),
          );
        }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );     
      }
      

    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(int value, String user, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("user", user);
      preferences.setString("pass", pass);
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.borderColor)
    );
    
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
              centerTitle: true,
              backgroundColor: MyColors.mainColor,
            ),
            body: Center(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sign in"),
                            Switch(
                              value: signUp,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  signUp = value;
                                });
                              },
                              activeColor: MyColors.thumbColor,
                            ),
                            const Text("Sign Up"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            onSaved: (newValue) => _username = newValue,
                            cursorColor: MyColors.borderColor,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(color: MyColors.borderColor),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor, width: 2)
                              ),
                            ),
                          ),
                        ),
                        signUp ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            onSaved: (newValue) => _email = newValue,
                            cursorColor: MyColors.borderColor,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: MyColors.borderColor),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor, width: 2)
                              ),
                            ),
                          ),
                        ) : const Padding(padding: EdgeInsets.all(10)),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            onSaved: (newValue) => _password = newValue,
                            cursorColor: MyColors.borderColor,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: MyColors.borderColor),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: MyColors.borderColor, width: 2)
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ]
                    ,)
                  ),
                  ElevatedButton(
                    onPressed: _submit, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyColors.buttonColor),
                    ),
                    child: Text(signUp ? "Sign Up" : "Sign in"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home(signOut: signOut, signedIn: false))
                        );
                      }, 
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(MyColors.buttonColor),
                      ),
                      child: const Text("Guest"),
                    ),
                  ),
                ],
              ),
            ),
          );
        case LoginStatus.signIn:
          return Home(signOut: signOut, signedIn: true);
    }
    
  }
}