import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchResults extends StatefulWidget {
  MatchResults({Key key, this.match, this.capseurs, this.capseur}) : super(key: key);

  final MatchEnded match;
  final List<Capseur> capseurs;
  final Capseur capseur;

  @override
  _MatchResultsState createState() => _MatchResultsState();
}

class _MatchResultsState extends State<MatchResults> {
  @override
  Widget build(BuildContext context) {
    if (widget.capseurs == null || widget.match == null) return LoadingWidget();

    Capseur capseur1 = widget.capseurs
        .firstWhere((capseur) => capseur.uid == widget.match.player1);
    Capseur capseur2 = widget.capseurs
        .firstWhere((capseur) => capseur.uid == widget.match.player2);

    if (widget.capseur != null){
      if (capseur2.uid == widget.capseur.uid ){
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(capseur1.firstname + ' ' + capseur1.lastname,
                      style: TextStyle(
                          color: widget.match.player1Won
                              ? kPrimaryColor
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300)),
                  onPressed: (){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new ProfilePage(capseur: capseur1),
                        ),
                    );
                  },
                ),
                Text(' - '),
                TextButton(
                  child: Text(capseur2.firstname + ' ' + capseur2.lastname,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: widget.match.player1Won
                              ? Colors.black
                              : kPrimaryColor)),
                  onPressed: (){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new ProfilePage(capseur: capseur2),
                        ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.match.scorePlayer1.toString() +
                  ' - ' +
                  widget.match.scorePlayer2.toString(),
              style: TextStyle(fontFamily: 'PirataOne', fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
