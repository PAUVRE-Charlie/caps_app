import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/pages/homePage.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:caps_app/pages/rankingPage.dart';
import 'package:caps_app/services/auth.dart';
import 'package:caps_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/capseur.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return StreamProvider<BasicUser>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'Caps',
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'NotoSansJP'),
          routes: {
            '/home': (context) => HomePage(),
            '/profile': (context) => ProfilePage(),
            '/ranking': (context) => RankingPage(),
            '/': (context) => Wrapper(),
          },
        ));
  }
}
