import 'package:cloud_functions/cloud_functions.dart';
import 'package:food_bridge/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: false);
  return firebaseApp;
}

Future<Map<String, dynamic>> callCloudFunction(
    Map<String, dynamic> data, String funcName) async {
  try {
    final result =
        await FirebaseFunctions.instance.httpsCallable(funcName).call(data);
    return {"success": true, "result": result};
  } on FirebaseFunctionsException catch (err) {
    return {"success": false, "err": err};
  }
}
