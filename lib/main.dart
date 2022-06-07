import 'package:firebase_core/firebase_core.dart';
import 'package:first_project/auth_controller.dart';
import 'package:first_project/screens/Splash_Screen.dart';

// import 'screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        brightness: Brightness.light,
      ),
      home: Splash(),
    );
  }
}
