import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_signin/ui/login_page.dart';
import 'package:flutter_google_signin/ui/login_status.dart';


GlobalKey<ScaffoldMessengerState> scaffoldMessengerState =
GlobalKey<ScaffoldMessengerState>();
GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerState,
      navigatorKey: navigatorState,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LoginSignUpPage(),
    );
  }
}

