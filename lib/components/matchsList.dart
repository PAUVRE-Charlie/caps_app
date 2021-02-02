import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchList extends StatefulWidget {
  MatchList({Key key, this.capseur}) : super(key: key);

  final Capseur
      capseur; // not mandatory, but if not null, the list will only contain matchs of this player

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    var matchs = Provider.of<List<MatchEnded>>(context);
    final capseurs = Provider.of<List<Capseur>>(context);

    if (matchs == null) return LoadingWidget();

    matchs.sort(((x, y) => y.date.compareTo(x.date)));
    if (widget.capseur != null) {
      matchs = matchs
          .where((match) =>
              match.player1 == widget.capseur.uid ||
              match.player2 == widget.capseur.uid)
          .toList();
    }

    return Column(
      children: [
        for (MatchEnded match in matchs)
          MatchResults(
              match: match, capseurs: capseurs, capseur: widget.capseur)
      ],
    );
  }
}
