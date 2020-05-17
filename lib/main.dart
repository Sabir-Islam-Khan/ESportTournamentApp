import 'package:events_freelance/UserSignin.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'LOG',
        debugShowCheckedModeBanner: false,
        color: Colors.blue,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.blue,
                ),
                elevation: 0.0,
                color: Colors.white)),
        home: HomePage());
  }
}
