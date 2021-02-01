import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:caps_app/pages/tournamentPage.dart';
import 'package:caps_app/pages/tournamentsMenuPage.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TournamentList extends StatefulWidget {
  TournamentList({Key key, this.capseur}) : super(key: key);

  final Capseur
      capseur; // not mandatory, but if not null, the list will only contain matchs of this player

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<TournamentList> {
  @override
  Widget build(BuildContext context) {
    final tournaments = Provider.of<List<TournamentInfo>>(context);

    if (tournaments == null) return LoadingWidget();

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          TournamentInfo tournament = tournaments[index];
          return ListTile(
            title: Text(tournament.name),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (ctxt) =>
                      StreamProvider<Map<String, Map<String, String>>>.value(
                    value: DatabaseService().capseursInTournaments,
                    child: StreamProvider<List<Capseur>>.value(
                      value: DatabaseService().capseurs,
                      child: StreamProvider<List<MatchEnded>>.value(
                        value: DatabaseService().matchs,
                        child: TournamentPage(tournamentInfo: tournament),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        itemCount: tournaments.length);
  }
}
