import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'matchsWaitingResults.dart';

class MatchWaitingList extends StatefulWidget {
  MatchWaitingList({Key key, this.capseur}) : super(key: key);

  final Capseur
      capseur; // not mandatory, but if not null, the list will only contain matchs of this player

  @override
  _MatchWaitingListState createState() => _MatchWaitingListState();
}

class _MatchWaitingListState extends State<MatchWaitingList> {
  @override
  Widget build(BuildContext context) {
    var matchs = Provider.of<List<MatchWaitingToBeValidated>>(context);
    final capseurs = Provider.of<List<Capseur>>(context);

    if (matchs == null) return LoadingWidget();

    if (widget.capseur != null) {
      matchs = matchs
          .where((match) =>
              match.player1 == widget.capseur.uid ||
              match.player2 == widget.capseur.uid)
          .toList();
    }

    return Column(
      children: [
        for (MatchWaitingToBeValidated match in matchs)
          MatchWaitingResults(
              match: match, capseurs: capseurs, capseur: widget.capseur)
      ],
    );
  }
}
