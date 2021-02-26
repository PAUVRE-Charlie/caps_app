import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/pages/authenticate.dart';
import 'package:caps_app/pages/homePage.dart';
import 'package:caps_app/pages/verifyPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);

    final auth = FirebaseAuth.instance;

    return user == null
        ? AuthenticatePage()
        : auth.currentUser.emailVerified
            ? HomePage()
            : VerifyPage();
  }
}
