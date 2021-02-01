import 'package:caps_app/components/tournamentsList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/tournamentInfo.dart';
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
            'Tournois',
            style: TextStyle(
                fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.3,
                child: Image(
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/bottle_-15deg.png"),
                ),
              ),
            ),
            TournamentList()
          ],
        ),
      ),
    );
  }
}
