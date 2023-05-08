import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/view/screens/home.dart';
import 'package:food_bridge/view/screens/login.dart';
import 'package:food_bridge/view/screens/trashbin.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      title: 'Food Bridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff16697A),
          secondary: const Color(0xff489FB5),
        ),
      ),
      // home: const TrashBinScreen(),
      home: getScreen(),
    );
  }

  getScreen() {
    if (FirebaseAuth.instance.currentUser != null) {
      return const HomeScreen();
    }
    return LoginScreen();
  }
}
