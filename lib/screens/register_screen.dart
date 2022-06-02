import 'package:first_project/auth_controller.dart';
import 'package:first_project/screens/Login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 42),
      body: SingleChildScrollView(
        child: Container(
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
                // autovalidateMode: AutovalidateMode.always,
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
                        validator: pwValidate,
                        onSaved: (text) {
                          _pw = text!;
                        },
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: SizedBox(
                          width: 200.0,
                          height: 50.0,
                          child: ElevatedButton(
                            child: Text('Register'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xfff60a5b),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState?.save();
                                print(_email);
                                AuthController.instance.register(_email, _pw);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return LoginScreen();
                          }));
                        },
                        child: Text("have an account? Login",
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

  String? pwValidate(text) {
    RegExp regExp1 = new RegExp(r'^(?=.*?[A-Z])');
    RegExp regExp2 = new RegExp(r'^(?=.*?[a-z])');
    RegExp regExp3 = new RegExp(r'^(?=.*?[0-9])');
    RegExp regExp4 = new RegExp(r'^(?=.*?[!@#\$&*~])');
    String error = "";
    if (text!.isEmpty) {
      error += "Password cannot be empty\n";
    }

    if (!regExp1.hasMatch(text)) {
      error += "Required minimum one upper case letter \n";
    }
    if (!regExp2.hasMatch(text)) {
      error += "Required minimum one lower case letter\n";
    }
    if (!regExp3.hasMatch(text)) {
      error += "Required minimum one Numeric character \n";
    }
    if (!regExp4.hasMatch(text)) {
      error += "Required minimum one Special Character( ! @ #  & * ~ etc )\n ";
    }
    if (text.length < 8) {
      error += "minimum 8 characters required\n";
    }
    if (error == "") {
      return null;
    } else {
      return error;
    }
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
}
