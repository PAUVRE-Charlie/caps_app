import 'package:caps_app/components/finalBoardView.dart';
import 'package:caps_app/components/matchsTournamentView.dart';
import 'package:caps_app/components/poolsView.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TournamentView extends StatelessWidget {
  const TournamentView(
      {Key key, @required this.tournament, @required this.capseurs})
      : super(key: key);

  final Tournament tournament;
  final List<Capseur> capseurs;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MatchWaitingToBeValidated>>.value(
      value: DatabaseService().matchsWaitingToBeValidated,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PoolsView(
              tournament: tournament,
              capseurs: capseurs,
            ),
            FinalBoardView(
              tournament: tournament,
              capseurs: capseurs,
            ),
            MatchsTournamentView(
              tournament: tournament,
              capseurs: capseurs,
            ),
          ],
        ),
      ),
    );
  }
}
