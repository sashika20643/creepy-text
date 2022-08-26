import 'package:first_project/auth_controller.dart';
import 'package:first_project/screens/Login_screen.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final tfdecoration = InputDecoration(
    hintText: "OTP",
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
                // autovalidateMode: AutovalidateMode.always,
                child: Container(
                  margin: const EdgeInsets.all(35.0),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: tfdecoration,
                        validator: otpValidate,
                        onSaved: (text) {
                          _email = text!;
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
                              primary: Color(0xff0a5c02),
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

  String? otpValidate(text) {
    RegExp regExp = new RegExp(r'^(?=.*?@)(?=.*?[.])');
    if (text!.isEmpty) {
      return "Email cannot be empty";
    } else if (!regExp.hasMatch(text)) {
      return "Not a valid email";
    }
    return null;
  }
}
