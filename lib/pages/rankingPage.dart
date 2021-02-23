import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/pages/profilePage.dart';
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
            leading: ArrowBackAppBar(),
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
              Background(
                image: "assets/images/bottle_-15deg.png",
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: RankingList(onPressed: (Capseur capseur) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (ctxt) => new ProfilePage(
                          capseur: capseur,
                        ),
                      ));
                }),
              ),
            ],
          ),
        ));
  }
}
