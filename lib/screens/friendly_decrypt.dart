import 'package:flutter/material.dart';

class FrindlyDecrypt extends StatefulWidget {
  const FrindlyDecrypt({Key? key}) : super(key: key);

  @override
  State<FrindlyDecrypt> createState() => _FrindlyDecryptState();
}

class _FrindlyDecryptState extends State<FrindlyDecrypt> {
  var _plaintext;
  var _decryptedtxt = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  child: Column(
                children: [
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
                      }
                    },
                    child: Text('Decrypt'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: "$_decryptedtxt",
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "",
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
                  )
                ],
              )),
            ),
          ),
        ));
  }
}
