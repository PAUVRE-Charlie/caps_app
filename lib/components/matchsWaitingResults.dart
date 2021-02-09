import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:flutter/material.dart';

class MatchWaitingResults extends StatefulWidget {
  MatchWaitingResults({Key key, this.match, this.capseurs, this.capseur})
      : super(key: key);

  final MatchWaitingToBeValidated match;
  final List<Capseur> capseurs;
  final Capseur capseur;

  @override
  _MatchWaitingResultsState createState() => _MatchWaitingResultsState();
}

class _MatchWaitingResultsState extends State<MatchWaitingResults> {
  @override
  Widget build(BuildContext context) {
    if (widget.capseurs == null || widget.match == null) return LoadingWidget();

    Capseur capseur1 = widget.capseurs
        .firstWhere((capseur) => capseur.uid == widget.match.player1);
    Capseur capseur2 = widget.capseurs
        .firstWhere((capseur) => capseur.uid == widget.match.player2);

    if (widget.capseur != null) {
      if (capseur2.uid == widget.capseur.uid) {
        capseur1 = widget.capseurs
            .firstWhere((capseur) => capseur.uid == widget.match.player2);
        capseur2 = widget.capseurs
            .firstWhere((capseur) => capseur.uid == widget.match.player1);
      }
    }

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(capseur1.username,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w300)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              new ProfilePage(capseur: capseur1),
                        ),
                      );
                    },
                  ),
                  Text(' - '),
                  TextButton(
                    child: Text(capseur2.username,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              new ProfilePage(capseur: capseur2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.match.scorePlayer1.toString() +
                  ' - ' +
                  widget.match.scorePlayer2.toString(),
              style: TextStyle(
                  fontFamily: 'PirataOne', fontSize: 30, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
