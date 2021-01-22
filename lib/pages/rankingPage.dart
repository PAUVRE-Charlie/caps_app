import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Capseur>>.value(
        value: DatabaseService().capseurs,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroundBaseColor,
            shadowColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: kSecondaryColor),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // delete this line when finish editing it and decomment the one in the onConfirm of startMatchMethod
              },
            ),
            title: Text(
              'Classements',
              style: TextStyle(
                  fontFamily: 'PirataOne',
                  fontSize: 30,
                  color: kSecondaryColor),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kBackgroundBaseColor, kBackgroundSecondColor]),
                ),
              ),
              RankingList(),
            ],
          ),
        ));
  }
}
