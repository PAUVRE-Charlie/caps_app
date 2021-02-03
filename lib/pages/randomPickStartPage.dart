import 'dart:math';

import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import 'matchPage.dart';

class RandomPickStartPage extends StatefulWidget {
  RandomPickStartPage(
      {Key key,
      this.title,
      this.capseur1,
      this.capseur2,
      this.bottlesNumber,
      this.pointsPerBottle})
      : super(key: key);

  final String title;
  final Capseur capseur1;
  final Capseur capseur2;
  final int bottlesNumber;
  final int pointsPerBottle;

  @override
  _RandomPickStartPageState createState() => _RandomPickStartPageState();
}

class _RandomPickStartPageState extends State<RandomPickStartPage> {
  Widget widgetToShow;

  @override
  void initState() {
    widgetToShow = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(),
        Text(
          "Pile ou caps...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: kPrimaryColor),
        ),
      ],
    );
    Future.delayed(const Duration(milliseconds: 3000), () {
      bool player1Starting = Random().nextBool();

      setState(() {
        widgetToShow = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "C'est à ${player1Starting ? widget.capseur1.firstname : widget.capseur2.firstname} de commencer !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            RaisedButton(
              color: kPrimaryColor,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (ctxt) => new MatchPage(
                            title: widget.title,
                            capseur2: widget.capseur2,
                            capseur1: widget.capseur1,
                            bottlesNumber: widget.bottlesNumber,
                            pointsPerBottle: widget.pointsPerBottle,
                            player1Starting: player1Starting,
                          )),
                );
              },
              child: Text(
                "C'est parti !",
                style: TextStyle(color: kWhiteColor),
              ),
            )
          ],
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            image: "assets/images/bottle_32deg.png",
          ),
          Center(
            child: widgetToShow,
          )
        ],
      ),
    );
  }
}
