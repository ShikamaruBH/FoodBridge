import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/view/chooserole.dart';
// import 'package:food_bridge/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Bridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff16697A),
          secondary: const Color(0xff489FB5),
        ),
      ),
      home: ChooseRoleScreen(),
    );
  }
}
