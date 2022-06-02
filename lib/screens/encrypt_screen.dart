import 'package:flutter/material.dart' hide Key;
import 'dart:math';
import 'package:encrypt/encrypt.dart'; // for the utf8.encode method

class EncryptScreen extends StatefulWidget {
  @override
  State<EncryptScreen> createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _plaintext;

  var ekey = "";
  var enctext = "";
  void encrypt() {
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
      appBar: AppBar(
        title: Text("Encrypt"),
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
                SizedBox(height: 20),
                SelectableText("$ekey"),
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
                  child: Text('encrypt'),
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
