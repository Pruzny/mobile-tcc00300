import 'package:flutter/material.dart';
import 'package:marketplace/helper/DatabaseHelper.dart';
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
    
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
              centerTitle: true,
            ),
            body: Container(
              child: Center(
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
                              ),
                              const Text("Sign Up"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _username = newValue,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          signUp ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _email = newValue,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ) : const Padding(padding: EdgeInsets.all(10)),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _password = newValue,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ),
                        ]
                      ,)
                    ),
                    ElevatedButton(
                      onPressed: _submit, 
                      child: Text(signUp ? "Sign Up" : "Sign in"),
                    ),
                  ],
                ),
              ),
            ),
          );
        case LoginStatus.signIn:
          return Home(signOut: signOut);
    }
    
  }
}