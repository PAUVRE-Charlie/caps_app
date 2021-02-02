import 'package:caps_app/components/finalBoardView.dart';
import 'package:caps_app/components/poolsView.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class TournamentView extends StatelessWidget {
  const TournamentView({Key key, @required this.tournament}) : super(key: key);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: TabBarView(
        children: [
          PoolsView(
            tournament: tournament,
          ),
          FinalBoardView(
            tournament: tournament,
          )
        ],
      ),
    );
  }
}
