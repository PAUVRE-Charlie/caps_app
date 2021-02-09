import 'dart:ui';

import 'package:caps_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:caps_app/models/player.dart';
import 'package:caps_app/data.dart';


class MatchResultEdit extends StatefulWidget {

  final int pointsRequired;
  final int pointsPerBottle;
  final Player player1;
  final Player player2;

  MatchResultEdit({this.pointsRequired, this.pointsPerBottle, this.player1, this.player2});

  @override
  _MatchResultEditState createState() => _MatchResultEditState();
}

class _MatchResultEditState extends State<MatchResultEdit> {
  Player winner;
  String error;

  @override
  void initState() {
    super.initState();
    error = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Match en ${widget.pointsRequired}')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.player2.capseur.username,
                      style: TextStyle(
                          color: widget.player2 == winner
                              ? kPrimaryColor
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300)),
                  Text(' - '),
                  Text(widget.player1.capseur.username,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: widget.player2 == winner
                              ? Colors.black
                              : kPrimaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontFamily: 'PirataOne', fontSize: 30),
                      onChanged: (value){
                        setState(() {
                          widget.player2.setScore(int.parse(value));
                          print(int.parse(value));
                          print(value.isEmpty);
                          winner = (widget.player2.score >= widget.player1.score) ? widget.player2 : widget.player1;
                          error = value.isEmpty ? 'rentrez une valeur'
                              : int.parse(value.toString())>=100 ? 'n\'exagerons pas...'
                              : int.parse(value.toString()) == widget.player1.score ? 'l\'égalité n\'est pas possible'
                              : '';
                        });
                      },
                    ),
                  ),
                ),
                Text(' - '),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontFamily: 'PirataOne', fontSize: 30),
                      onChanged: (value){
                        setState(() {
                          widget.player1.setScore(int.parse(value));
                          print(int.parse(value));
                          print(value.isEmpty);
                          winner = (widget.player2.score >= widget.player1.score) ? widget.player2 : widget.player1;
                          error = value.isEmpty ? 'rentrez une valeur'
                              : int.parse(value.toString())>=100 ? 'n\'exagerons pas...'
                              : int.parse(value.toString()) == widget.player2.score ? 'l\'égalité n\'est pas possible'
                              : '';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
                child: Text(
                  "Valider",
                  style: TextStyle(color: kWhiteColor),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  if (widget.player2.score < widget.pointsRequired && widget.player1.score < widget.pointsRequired){
                    setState(() {
                      error = 'le score du vainqueur n\'est pas suffisant';
                    });
                  }
                  if (error == ''){
                    endGame(winner, widget.pointsRequired, widget.pointsPerBottle);
                  }
                }),
            Text(error, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, color: kPrimaryColor, fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }

  endGame(Player winner, int pointsRequired, int pointsPerBottle) {
    /* UPDATE ALL THE VARIABLES OF BOTH CAPSEURS IN THE SERVER */
    DatabaseService().updateMatchWaitingToBeValidatedData(
        widget.player1.capseur.uid,
        widget.player2.capseur.uid,
        widget.player1.score,
        widget.player2.score,
        pointsRequired,
        pointsPerBottle,
        widget.player1.capsHitInThisGame,
        widget.player1.capsThrowInThisGame,
        widget.player2.capsHitInThisGame,
        widget.player2.capsThrowInThisGame);

    Navigator.of(this.context).pop();
  }
}



