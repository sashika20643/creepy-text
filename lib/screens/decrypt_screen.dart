import 'package:flutter/material.dart' hide Key;

import 'package:encrypt/encrypt.dart'; // for the utf8.encode method

class DecryptScreen extends StatefulWidget {
  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _plaintext;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text("Plain text"),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: "Input text to encrypt"),
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
                Text("Key"),
                TextFormField(
                  decoration: InputDecoration(hintText: "Input key to encrypt"),
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
                        MaterialStateProperty.all<Color>(Colors.brown),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      encrypt();
                    }
                    print("pressed");
                  },
                  child: Text('Decrypt'),
                ),
                SizedBox(height: 30),
                SelectableText("$enctext")
              ],
            ),
          )
        ],
      ),
    );
  }
}
