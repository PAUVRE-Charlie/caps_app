import 'package:caps_app/components/TournamentView.dart';
import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/tournamentsList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/participant.dart';
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
    var matchsOfTournaments = Provider.of<List<MatchOfTournament>>(context);
    var matchs = Provider.of<List<MatchEnded>>(context);
    var pools = Provider.of<List<Pool>>(context);
    var capseurs = Provider.of<List<Capseur>>(context);
    var capseursInTournaments =
        Provider.of<Map<String, Map<String, String>>>(context);

    Widget widgetToShow;

    if (capseurs == null ||
        matchs == null ||
        matchsOfTournaments == null ||
        capseursInTournaments == null ||
        pools == null) {
      widgetToShow = new LoadingWidget();
    } else {
      matchsOfTournaments = matchsOfTournaments
          .where((match) => match.tournamentUid == tournamentInfo.uid)
          .toList();

      matchs = matchs.where((match) {
        for (MatchOfTournament matchOfTournament in matchsOfTournaments) {
          if (matchOfTournament.match == match.uid) return true;
        }
        return false;
      });

      pools = pools
          .where((pool) => pool.tournamentUid == tournamentInfo.uid)
          .toList();

      matchsOfTournaments.forEach((matchofTournament) {
        if (matchofTournament.poolUid != null) {
          pools
              .firstWhere((pool) => pool.uid == matchofTournament.poolUid)
              .addMatch(matchofTournament);
        } else {}
      });
      Tournament tournament =
          new Tournament(tournamentInfo, pools, matchsOfTournaments, matchs);

      Map<String, String> tournamentAssociation =
          capseursInTournaments[tournamentInfo.uid];

      tournamentAssociation.forEach((capseurUid, poolUid) {
        pools.firstWhere((pool) => pool.uid == poolUid).addParticipant(
            new Participant.initial(
                capseurs.firstWhere((capseur) => capseur.uid == capseurUid)));
      });

      for (Pool pool in pools) {
        for (MatchOfTournament matchOfTournament in pool.matchs) {
          MatchEnded match = matchs
              .firstWhere((match) => match.uid == matchOfTournament.match);

          Participant participant1 = pool.participants.firstWhere(
              (participant) => participant.capseur.uid == match.player1);
          Participant participant2 = pool.participants.firstWhere(
              (participant) => participant.capseur.uid == match.player2);

          int capsAverageForParticipant1 =
              match.scorePlayer1 - match.scorePlayer2;

          participant1.addCapsAverage(capsAverageForParticipant1);
          participant2.addCapsAverage(-capsAverageForParticipant1);
        }
      }

      widgetToShow = TournamentView(tournament: tournament);
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroundBaseColor,
            shadowColor: Colors.transparent,
            leading: ArrowBackAppBar(),
            bottom: TabBar(
              indicatorColor: kSecondaryColor,
              tabs: [
                Tab(
                  child:
                      Text('Poules', style: TextStyle(color: kSecondaryColor)),
                  icon: Icon(
                    Icons.table_chart,
                    color: kSecondaryColor,
                  ),
                ),
                Tab(
                  child: Text('Tableau final',
                      style: TextStyle(color: kSecondaryColor)),
                  icon: Icon(
                    Icons.list_alt,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
            title: Text(
              tournamentInfo.name,
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
              widgetToShow
            ],
          ),
        ));
  }
}
