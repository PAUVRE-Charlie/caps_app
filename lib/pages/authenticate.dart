import 'package:caps_app/pages/sign_in.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class AuthenticatePage extends StatefulWidget {
  AuthenticatePage({Key key}) : super(key: key);

  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundBaseColor,
          shadowColor: Colors.transparent,
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [kBackgroundBaseColor, kBackgroundSecondColor])),
          ),
          SignIn()
        ]));
  }
}
