import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/view/screens/finddonation.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      title: 'Food Bridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff16697A),
          secondary: const Color(0xff489FB5),
        ),
      ),
      home: getScreen(),
    );
  }

  getScreen() {
    // if (FirebaseAuth.instance.currentUser != null) {
    //   return const HomeScreen();
    // }
    // return LoginScreen();
    return const FindDonationScreen();
  }
}
