import 'package:caps_app/components/loading.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'matchResults.dart';
import 'matchsWaitingResults.dart';

class MatchsTournamentView extends StatelessWidget {
  const MatchsTournamentView({Key key, this.capseurs, this.tournament})
      : super(key: key);

  final List<Capseur> capseurs;
  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    List<MatchWaitingToBeValidated> matchsWaiting =
        Provider.of<List<MatchWaitingToBeValidated>>(context);

    if (matchsWaiting == null || tournament.matchs == null)
      return LoadingWidget();

    if (matchsWaiting.isEmpty && tournament.matchs.isEmpty)
      return Center(
          child: Text(
        "Aucun match n'a été joué",
        style: TextStyle(
            fontFamily: 'PirataOne', fontSize: 35, color: Colors.black),
      ));

    return SingleChildScrollView(
      child: Column(
        children: [
          for (MatchWaitingToBeValidated match in matchsWaiting.where(
              (match) => match.tournamentUid == tournament.tournamentInfo.uid))
            MatchWaitingResults(
              capseurs: capseurs,
              match: match,
            ),
          for (MatchEnded match in tournament.matchs)
            MatchResults(
              capseurs: capseurs,
              match: match,
            )
        ],
      ),
    );
  }
}
