import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/Login_screen.dart';
import 'package:first_project/screens/home_page.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AuthController extends GetxController {
  static var isLoading = false.obs;

  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.off(() => MyHomePage());
    }
  }

  void register(String email, password) async {
    try {
      isLoading.value = true;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("About user", "user message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 203, 99, 99),
          titleText: Text(
            "Registration failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void login(String email, password) async {
    try {
      isLoading = true.obs;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
    } catch (e) {
      Get.offAll(() => LoginScreen());
      print(e);
      isLoading.value = false;

      Get.snackbar("About user", "user message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 203, 99, 99),
          titleText: Text(
            "Logging failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void logout() {
    auth.signOut();
  }
}
