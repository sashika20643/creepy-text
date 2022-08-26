import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Key;
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class EncryptScreen extends StatefulWidget {
  @override
  State<EncryptScreen> createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  static Encrypted? fernetEncrypted;
  static var fernetDecrypted;
  var massege_id;

  String dropdownvalue = 'Salsa 20';
  var _plaintext;
  var items = ['Salsa 20', 'AES', 'Fernet'];
  FirebaseAuth auth = FirebaseAuth.instance;

  var ekey = "";

  var enctext = "";
  var _email = "";
//data base part start
  final databaseRef = FirebaseDatabase.instance.ref();

//data base part end
// void RSA(){

//    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
//   final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
//   final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
//   final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

//   final encrypted = encrypter.encrypt(plainText);
//   final decrypted = encrypter.decrypt(encrypted);

//   print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//   print(encrypted.base64);
// }

  void Salsa() {
    setState(() {
      print("Salsa20");
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
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
      generateId();
      enctext = massege_id + encrypted.base64;
    });
  }

  void fernet() {
    setState(() {
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      final plainText = '$_plaintext';
      ekey = getRandomString(32);
      final key = Key.fromUtf8(ekey);
      final iv = IV.fromLength(16);

      final fernet = Fernet(key);
      final encrypter = Encrypter(fernet);

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      generateId();
      enctext = massege_id + encrypted.base64;
      fernetDecrypted = encrypter.decrypt(encrypted);
      print(fernetDecrypted);
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
      generateId();
      enctext = massege_id + encrypted.base64;
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
                SizedBox(
                  height: 15,
                ),
                Visibility(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              elevation: 16,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 50),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        key: _formKey2,
                                        child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Input email",
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                              fillColor: Color.fromARGB(
                                                  255, 141, 138, 138),
                                            ),
                                            validator: emailValidate,
                                            onSaved: (text) {
                                              _email = text!;
                                            }),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          _formKey2.currentState?.save();

                                          await checkIfEmailInUse(_email);

                                          // sendkey(ekey, _email, dropdownvalue);
                                        },
                                        icon: Icon(Icons.send),
                                        label: Text("send key"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.send),
                    label: Text("send key"),
                  ),
                  visible: ekey == "" ? false : true,
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
                      } else if (dropdownvalue == "Fernet") {
                        fernet();
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
                ),
                Visibility(
                  child: IconButton(
                    onPressed: () async {
                      final url = 'https://api.whatsapp.com/send?text=$enctext';
                      await launch(url);
                    },
                    icon: Icon(Icons.whatsapp),
                    color: Colors.green,
                    iconSize: 50,
                  ),
                  visible: ekey == "" ? false : true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String? emailValidate(text) {
    RegExp regExp = new RegExp(r'^(?=.*?@)(?=.*?[.])');
    if (text!.isEmpty) {
      return "Email cannot be empty";
    } else if (!regExp.hasMatch(text)) {
      return "Not a valid email";
    }
    return null;
  }

  Future<bool> checkIfEmailInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        sendkey(ekey, _email, dropdownvalue);
        Get.snackbar(
          "About user",
          ".",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 35, 113, 28),
          titleText: Text(
            "Successfully sended",
            style: TextStyle(color: Colors.white),
          ),
        );
        print("have");
        return true;
      } else {
        print("not have");
        // Return false because email adress is not in use
        Get.snackbar(
          "About user",
          "try with another email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 113, 103, 28),
          titleText: Text(
            "No user found",
            style: TextStyle(color: Colors.white),
          ),
        );
        return false;
      }
    } catch (error) {
      // Handle error
      // ...
      return true;
    }
  }

  void generateId() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    DateTime now = DateTime.now();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    massege_id = getRandomString(8);

    print(massege_id);
  }

  void sendkey(String key, String email, String algo) async {
    print(email);
    await databaseRef
        .child("permission")
        .push()
        .set({'ID': email + massege_id, 'key': key, 'algo_type': algo});
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
