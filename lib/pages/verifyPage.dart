import 'dart:async';

import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/pages/homePage.dart';
import 'package:caps_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key key, this.onCheck}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();

  final Function onCheck;
}

class _VerifyPageState extends State<VerifyPage> {
  final auth = FirebaseAuth.instance;
  User user;

  bool sent;

  @override
  void initState() {
    user = auth.currentUser;
    sent = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        title: Text(
          "Confirmation d'email",
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
        ),
      ),
      body: Stack(
        children: [
          Background(
            image: "assets/images/bottle_-15deg.png",
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                'Nous devons vérifier votre email: ${user.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "NotoSansJP"),
              )),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: Text("Envoyer le mail de confirmation",
                      style: TextStyle(color: kWhiteColor)),
                  color: kPrimaryColor,
                  onPressed: !sent
                      ? () {
                          setState(() {
                            user.sendEmailVerification();
                            sent = true;
                          });
                        }
                      : null),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: Text("Check", style: TextStyle(color: kWhiteColor)),
                  color: kSecondaryColor,
                  onPressed: () {
                    user.reload();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Wrapper()));
                  }),
              SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
