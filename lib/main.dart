import 'package:caps_app/pages/homePage.dart';
import 'package:caps_app/services/auth.dart';
import 'package:caps_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'capseur.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Capseur>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'Caps',
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'NotoSansJP'),
          routes: {
            '/home': (context) => HomePage(),
            '/': (context) => Wrapper(),
          },
        ));
  }
}
