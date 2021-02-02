import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';

class FinalBoardView extends StatefulWidget {
  FinalBoardView({Key key, @required this.tournament}) : super(key: key);

  final Tournament tournament;

  @override
  _PoolsViewState createState() => _PoolsViewState();
}

class _PoolsViewState extends State<FinalBoardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Tableau final"),
    );
  }
}
