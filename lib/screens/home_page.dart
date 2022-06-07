import 'package:first_project/screens/friendly_decrypt.dart';

import '../auth_controller.dart';
import 'encrypt_screen.dart';
import 'decrypt_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 42),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 105, 99),
        title: Text("ECT APP"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return EncryptScreen();
                              }));
                            },
                            child: Image(
                              image: AssetImage('assets/images/encrypt.png'),
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Encrypt",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ]),
                    Spacer(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return FrindlyDecrypt();
                              }));
                            },
                            child: Image(
                              image: AssetImage('assets/images/decrypt.png'),
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Decrypt",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ])
                  ],
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return DecryptScreen();
                          }));
                        },
                        child: Image(
                          image: AssetImage('assets/images/decryptwithkey.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Friendly Decrypt ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ]),
                    Spacer(),
                    Column(children: [
                      InkWell(
                        onTap: AuthController.instance.logout,
                        child: Image(
                          image: AssetImage('assets/images/logout.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ])
                  ],
                )
              ])),
        ),
      ),
    );
  }
}
