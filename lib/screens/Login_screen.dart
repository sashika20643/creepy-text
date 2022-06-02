import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/register_screen.dart';
import 'package:flutter/material.dart';

import '../auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = AuthController.isLoading.value;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final tfdecoration = InputDecoration(
    hintText: "Email",
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    prefixIcon: Icon(
      Icons.account_circle,
      color: Color.fromARGB(255, 255, 255, 255),
    ),
    filled: true,
    hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    fillColor: Color.fromARGB(255, 141, 138, 138),
  );
  String _email = "";
  String _pw = "";

  get h => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 42),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 16, 12, 42),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 200,
              ),
              Form(
                key: _formkey,
                child: Container(
                  margin: const EdgeInsets.all(35.0),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: tfdecoration,
                        validator: emailValidate,
                        onSaved: (text) {
                          _email = text!;
                        },
                      ),
                      SizedBox(height: 50),
                      TextFormField(
                        obscureText: true,
                        decoration: tfdecoration.copyWith(
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (text) {
                          _pw = text!;
                        },
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: SizedBox(
                          width: 200.0,
                          height: 50.0,
                          child: ElevatedButton.icon(
                            label: Text(AuthController.isLoading.value
                                ? 'processing..'
                                : 'Login'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff0a5c02),
                            ),
                            onPressed: () {
                              if (!AuthController.isLoading.value) {
                                if (_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                  AuthController.instance.login(_email, _pw);
                                  print(AuthController.isLoading.value);
                                  setState(() {
                                    isLoading = AuthController.isLoading.value;
                                  });
                                }
                              }
                            },
                            icon: AuthController.isLoading.value
                                ? CircularProgressIndicator()
                                : Icon(Icons.login),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return RegisterScreen();
                          }));
                        },
                        child: Text("Don't have an account? Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  )),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  String? emailValidate(text) {
    RegExp regExp = new RegExp(r'^(?=.*?@)(?=.*?[.])');
    if (text!.isEmpty) {
      return "Email cannot be empty";
    } else if (!regExp.hasMatch(text)) {
      return "Not a valid email";
    }
    return null;
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _pw);
  }
}
