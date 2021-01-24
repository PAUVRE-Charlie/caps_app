import 'package:caps_app/components/register.dart';
import 'package:caps_app/components/signIn.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundBaseColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Text("Caps",
              style: TextStyle(
                  color: kPrimaryColor, fontFamily: 'PirataOne', fontSize: 40)),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Sign in', style: TextStyle(color: kPrimaryColor)),
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
              ),
              Tab(
                child: Text('Register', style: TextStyle(color: kPrimaryColor)),
                icon: Icon(
                  Icons.person_add,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kBackgroundBaseColor, kBackgroundSecondColor])),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: TabBarView(
                children: [
                  SignIn(),
                  Register(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
