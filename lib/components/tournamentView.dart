import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentView extends StatefulWidget {
  TournamentView({Key key, @required this.tournament}) : super(key: key);

  final Tournament tournament;

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.tournament.pools.first.capseurs.first.firstname);
  }
}
