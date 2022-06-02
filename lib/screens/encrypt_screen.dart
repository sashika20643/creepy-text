import 'package:flutter/material.dart' hide Key;
import 'dart:math';
import 'package:encrypt/encrypt.dart'; // for the utf8.encode method
import 'dart:convert';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/api.dart';

class EncryptScreen extends StatefulWidget {
  @override
  State<EncryptScreen> createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownvalue = 'Salsa 20';
  var _plaintext;
  var items = [
    'Salsa 20',
    'AES',
  ];
  var ekey = "";
  var enctext = "";

  void Salsa() {
    setState(() {
      print("Salsa20");
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890*&^%#@!?/';
      Random _rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      final plainText = '$_plaintext';
      ekey = getRandomString(32);
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(8);

      final encrypter = Encrypter(Salsa20(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      enctext = encrypted.base64;
    });
  }

  void ASE() {
    print("AES");
    setState(() {
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      final plainText = '$_plaintext';
      ekey = getRandomString(16);
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      enctext = encrypted.base64;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var key = utf8.encode('p@ssw0rd');
    // var bytes = utf8.encode("foobar");

    // var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    // var digest = hmacSha256.convert(bytes);

    // print("HMAC digest as bytes: ${digest.bytes}");
    // print("HMAC digest as hex string: $digest");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 42),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 105, 99),
        title: Text("Encrypt"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromARGB(255, 96, 105, 99),
                      border: Border.all()),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    focusColor: Colors.grey,
                    dropdownColor: Color.fromARGB(255, 96, 105, 99),
                    style: TextStyle(color: Colors.white),
                    icon: Padding(
                        //Icon at tail, arrow bottom is default icon
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.arrow_circle_down_sharp,
                          color: Colors.white,
                        )),
                    isExpanded: true,

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Input text to encrypt",
                    filled: true,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    fillColor: Color.fromARGB(255, 141, 138, 138),
                  ),
                  maxLines: 5,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "text cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (text) {
                    _plaintext = text;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Key",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                SizedBox(height: 20),
                SelectableText(
                  " $ekey",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(30.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (dropdownvalue == "Salsa 20") {
                        Salsa();
                      } else if (dropdownvalue == "AES") {
                        ASE();
                      }
                    }
                    print("pressed");
                  },
                  child: Text(
                    'encrypt',
                  ),
                ),
                SizedBox(height: 30),
                SelectableText(
                  "$enctext",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
