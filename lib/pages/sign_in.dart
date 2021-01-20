import 'package:caps_app/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        RaisedButton(onPressed: () {
          _auth.signInAnon();
        })
      ],
    ));
  }
}
