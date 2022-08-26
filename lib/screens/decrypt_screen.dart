import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart' hide Key;

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart'; // for the utf8.encode method
import 'package:crypto/crypto.dart';

class DecryptScreen extends StatefulWidget {
  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref();
  FirebaseAuth auth = FirebaseAuth.instance;

  String dropdownvalue = 'Salsa 20';
  var _plaintext;
  var massege_id;

  var ekey;
  var enctext = "";

  Future<void> checkPremisson() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("permission");
      final User? user = auth.currentUser;
      final email = user?.email;
      var mid = massege_id;
      await ref.orderByChild("ID").equalTo(email! + mid).once().then((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> items =
              event.snapshot.value as Map<dynamic, dynamic>;
          ekey = items.values.toList().first["key"];
          var algo_type = items.values.toList().first["algo_type"];
          if (algo_type == "AES")
            decryptAes();
          else if (algo_type == "Salsa 20")
            decryptSalsa20();
          else if (algo_type == "Fernet") decryptfernet();
        } else {
          Get.snackbar(
            "About permission",
            "You do not have permission",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 113, 103, 28),
            titleText: Text(
              "check again",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      });
      // FirebaseFirestore.instance
      //     .collection("permission")
      //     .where('user_id', isEqualTo: email)
      //     .where('massege_id',
      //         isEqualTo: 'kBAnD51XFVf2V5xri8LO3dGeKLJ22022669126')
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //               querySnapshot.docs.forEach((doc) {
      //       print(doc["first_name"]);
      //   });
      //   });
    } catch (e) {
      print(e.toString());
    }
  }

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

  void decryptfernet() {
    setState(() {
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(16);

      final fernet = Fernet(key);
      final encrypter = Encrypter(fernet);

      final decrypted = encrypter.decrypt64(_plaintext);

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
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Input text to decrypt",
                    filled: true,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    fillColor: Color.fromARGB(255, 141, 138, 138),
                  ),
                  maxLines: 10,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "text cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (text) {
                    _plaintext = text?.substring(8, text.length);
                    massege_id = text?.substring(0, 8);
                    print(massege_id);
                  },
                ),
                SizedBox(height: 16),
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

                      checkPremisson();
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
