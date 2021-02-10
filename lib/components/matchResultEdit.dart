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

  MatchResultEdit(
      {this.pointsRequired, this.pointsPerBottle, this.player1, this.player2});

  @override
  _MatchResultEditState createState() => _MatchResultEditState();
}

class _MatchResultEditState extends State<MatchResultEdit> {
  Player winner;
  String error;
  final textController1 = TextEditingController(text: '');
  final textController2 = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    error = '';
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
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
                      controller: textController2,
                      onChanged: (val){
                        setState(() {
                          widget.player2.setScore(int.parse(val));
                          print(int.parse(val));
                          winner = widget.player1.score > widget.player2.score ? widget.player1 : widget.player2;
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
                      controller: textController1,
                      onChanged: (val){
                        setState(() {
                          widget.player1.setScore(int.parse(val));
                          print(int.parse(val));
                          winner = widget.player1.score > widget.player2.score ? widget.player1 : widget.player2;
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
                  if (textController2.value.text == '' ||
                      textController1.value.text == '' ||
                      int.parse(textController1.value.text) < 0 ||
                      int.parse(textController2.value.text) < 0 ||
                      int.parse(textController1.value.text) > 100 ||
                      int.parse(textController2.value.text) > 100) {
                    setState(() {
                      error =
                          'Au moins un score est non valide (entre 0 et 100)';
                    });
                  } else if ((int.parse(textController1.value.text) <
                          widget.pointsRequired &&
                      int.parse(textController2.value.text) <
                          widget.pointsRequired)) {
                    setState(() {
                      error = 'Le score du vainqueur n\'est pas suffisant';
                    });
                  } else if (int.parse(textController1.value.text) ==
                      (int.parse(textController2.value.text))) {
                    setState(() {
                      error = 'Il ne peut pas y avoir égalité';
                    });
                  }else if (int.parse(textController1.value.text) >= widget.pointsRequired &&
    int.parse(textController2.value.text) >= widget.pointsRequired){
                      setState(() {
                        error =
                        'Les 2 scores ne peuvent pas être supérieur à ${widget.pointsRequired}';
                      });
                  }else {
                    widget.player1
                        .setScore(int.parse(textController1.value.text));
                    widget.player2
                        .setScore(int.parse(textController2.value.text));

                    DatabaseService().updateMatchWaitingToBeValidatedData(
                        widget.player1.capseur.uid,
                        widget.player2.capseur.uid,
                        widget.player1.score,
                        widget.player2.score,
                        widget.pointsRequired,
                        widget.pointsPerBottle,
                        widget.player1.capsHitInThisGame,
                        widget.player1.capsThrowInThisGame,
                        widget.player2.capsHitInThisGame,
                        widget.player2.capsThrowInThisGame);

                    Navigator.of(this.context).pop();
                  }
                }),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.0,
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
