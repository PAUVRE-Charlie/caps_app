import 'package:caps_app/capseur.dart';
import 'package:caps_app/pages/authenticate.dart';
import 'package:caps_app/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Capseur>(context);

    return user == null ? AuthenticatePage() : HomePage();
  }
}
