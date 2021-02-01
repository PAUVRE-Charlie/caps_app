import 'package:caps_app/components/TournamentView.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/tournamentsList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class TournamentPage extends StatelessWidget {
  final TournamentInfo tournamentInfo;

  TournamentPage({Key key, @required this.tournamentInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var matchs = Provider.of<List<MatchEnded>>(context);
    var capseurs = Provider.of<List<Capseur>>(context);
    var capseursInTournaments =
        Provider.of<Map<String, Map<String, String>>>(context);

    Widget widgetToShow;

    if (capseurs == null || matchs == null || capseursInTournaments == null) {
      widgetToShow = new LoadingWidget();
    } else {
      matchs = matchs
          .where((match) => match.uidTournament == tournamentInfo.uid)
          .toList();

      Map<String, String> tournamentAssociation =
          capseursInTournaments[tournamentInfo.uid];

      List<Pool> pools = new List();

      bool _newPool;
      Capseur _capseurInAssociation;

      tournamentAssociation.forEach((capseurUid, poolUid) {
        _newPool = true;
        _capseurInAssociation =
            capseurs.firstWhere((capseur) => capseur.uid == capseurUid);
        for (Pool pool in pools) {
          if (pool.uid == poolUid) {
            pool.addCapseur(_capseurInAssociation);
            _newPool = false;
          }
        }
        if (_newPool) {
          Pool pool = new Pool(poolUid);
          pool.addCapseur(_capseurInAssociation);
          pools.add(pool);
        }
      });

      matchs.forEach((match) {
        pools.firstWhere((pool) => pool.uid == match.poolUid).addMatch(match);
      });

      Tournament tournament = new Tournament(tournamentInfo, pools, matchs);
      widgetToShow = TournamentView(tournament: tournament);
    }

    return Scaffold(
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
          tournamentInfo.name,
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
          widgetToShow
        ],
      ),
    );
  }
}
