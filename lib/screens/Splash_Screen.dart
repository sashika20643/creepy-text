import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login_screen.dart';
import 'home_page.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return LoginScreen();
          }
        },
      ),
      // body: Center(
      //   child: Container(
      //       child: Text("Splash Screen", style: TextStyle(fontSize: 24))),
      // ),
    );
  }
}
