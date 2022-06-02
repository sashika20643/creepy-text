import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 42),
      body: Center(
        child: Container(
            child: Image(
          image: AssetImage('assets/images/logo.png'),
          width: 200,
          height: 200,
        )),
      ),
    );
  }
}
