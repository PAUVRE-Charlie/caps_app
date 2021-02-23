import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/matchsList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class LastMatchs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MatchEnded>>.value(
        value: DatabaseService().matchs,
        child: StreamProvider<List<Capseur>>.value(
          value: DatabaseService().capseurs,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kBackgroundBaseColor,
              shadowColor: Colors.transparent,
              leading: ArrowBackAppBar(),
              title: Text(
                'Derniers matchs',
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
                SingleChildScrollView(
                  child: MatchList(
                    maxMatchsDisplayed: 50,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
