import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/tournamentsList.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:caps_app/pages/createTournamentPage.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class TournamentsMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TournamentInfo>>.value(
      value: DatabaseService().tournaments,
      child: Scaffold(
        floatingActionButton: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (ctxt) => new CreateTournamentPage()));
          },
          child: Icon(
            Icons.add,
            color: kWhiteColor,
          ),
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          color: kSecondaryColor,
        ),
        appBar: AppBar(
          backgroundColor: kBackgroundBaseColor,
          shadowColor: Colors.transparent,
          leading: ArrowBackAppBar(),
          title: Text(
            'Tournois',
            style: TextStyle(
                fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
          ),
        ),
        body: Stack(
          children: [
            Background(
              image: "assets/images/bottle_-15deg.png",
            ),
            TournamentList()
          ],
        ),
      ),
    );
  }
}
