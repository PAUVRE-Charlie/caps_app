import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/register.dart';
import 'package:caps_app/components/signIn.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            indicatorColor: kPrimaryColor,
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
            Background(),
            Container(
              padding: EdgeInsets.all(30),
              child: TabBarView(
                children: [
                  SignIn(),
                  StreamProvider<List<Capseur>>.value(
                    value: DatabaseService().capseurs,
                    child: Register(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
