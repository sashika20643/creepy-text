import 'package:flutter/material.dart' hide Key;

import 'package:encrypt/encrypt.dart'; // for the utf8.encode method

class DecryptScreen extends StatefulWidget {
  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownvalue = 'Salsa 20';
  var _plaintext;
  var items = [
    'Salsa 20',
    'AES',
  ];

  var ekey;
  var enctext = "";
  void encrypt() {
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
      final iv = IV.fromLength(16);

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
      body: ListView(
        padding: EdgeInsets.all(15.0),
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
                SizedBox(height: 20),
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
                Text("Key",
                    style: TextStyle(color: Colors.green, fontSize: 20)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Input key to encrypt",
                    filled: true,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    fillColor: Color.fromARGB(255, 141, 138, 138),
                  ),
                  maxLength: 20,
                  onSaved: (text) {
                    ekey = text;
                  },
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
                      encrypt();
                    }
                  },
                  child: Text('Decrypt'),
                ),
                SizedBox(height: 30),
                SelectableText("$enctext",
                    style: TextStyle(color: Colors.green, fontSize: 18))
              ],
            ),
          )
        ],
      ),
    );
  }
}
