import 'package:flutter/material.dart' hide Key;
import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:get/get.dart'; // for the utf8.encode method

class FrindlyDecrypt extends StatefulWidget {
  @override
  State<FrindlyDecrypt> createState() => _FrindlyDecryptState();
}

class _FrindlyDecryptState extends State<FrindlyDecrypt> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownvalue = 'Salsa 20';
  var _plaintext;
  var massege_id;
  var items = [
    'Salsa 20',
    'AES',
    'Fernet'
  ];

  var ekey;
  var enctext = "";

  //database part
void decryptfernet() {
    setState(() {
      final key = Key.fromUtf8(ekey);
     final iv = IV.fromLength(16);
    
    final fernet = Fernet(key);
      final encrypter = Encrypter(fernet);
   
     
      final decrypted =encrypter.decrypt64(_plaintext);

      enctext = decrypted.toString();
    });}
  void decryptAes() {
    setState(() {
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(key));

      final decrypted = encrypter.decrypt64(_plaintext, iv: iv);

      enctext = decrypted.toString();
    });
  }

  void decryptSalsa20() {
    setState(() {
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(8);

      final encrypter = Encrypter(Salsa20(key));

      final decrypted = encrypter.decrypt64(_plaintext, iv: iv);

      enctext = decrypted.toString();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 12, 42),
        appBar: AppBar(
          title: Text("Decrypt"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 80),
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Form(
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
                        height: 30,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Input text to decrypt",
                          filled: true,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
                          _plaintext = text?.substring(40, text.length);
                          massege_id = text?.substring(0, 40);
                          print(massege_id);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Key",
                          style: TextStyle(color: Colors.green, fontSize: 20)),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Input key to decrypt",
                          filled: true,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          fillColor: Color.fromARGB(255, 141, 138, 138),
                        ),
                        maxLength: 40,
                        onSaved: (text) {
                          ekey = text;
                        },
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(30.0)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (dropdownvalue == "AES") {
                              decryptAes();
                            } else if (dropdownvalue == "Salsa 20") {
                              decryptSalsa20();
                            }
                            else if (dropdownvalue == "Fernet") {
                              decryptfernet();
                            }
                          }
                        },
                        child: Text('Decrypt'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText("$enctext",
                          style: TextStyle(color: Colors.green, fontSize: 18))
                    ],
                  )),
            ),
          ),
        ));
  }

  void getdata(String massage_id, String key, String email) {}
}
