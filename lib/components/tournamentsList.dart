import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
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

    DatabaseService db = new DatabaseService();
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          TournamentInfo tournament = tournaments[index];
          return ListTile(
            title: Text(
              tournament.name,
              style: TextStyle(fontFamily: 'PirataOne', fontSize: 25),
            ),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (ctxt) =>
                      StreamProvider<Map<String, List<Participant>>>.value(
                    value: db.capseursInTournaments,
                    child: StreamProvider<List<Capseur>>.value(
                      value: db.capseurs,
                      child: StreamProvider<List<MatchOfTournament>>.value(
                        value: db.matchsOfTournaments,
                        child: StreamProvider<List<Pool>>.value(
                          value: db.pools,
                          child: StreamProvider<List<MatchEnded>>.value(
                            value: db.matchs,
                            child: TournamentPage(tournamentInfo: tournament),
                          ),
                        ),
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
