import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/pages/matchPage.dart';
import 'package:caps_app/models/player.dart';
import 'package:caps_app/pages/randomPickStartPage.dart';
import 'package:caps_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'capseur.dart';

class Game {
  BuildContext _context;
  Player _player1;
  Player _player2;
  int _reverseCount;
  int _pointsRequired;
  int _pointsPerBottle;
  bool _player1Starting;

  Game.initial(Capseur capseur1, Capseur capseur2, int bottlesNumber,
      int pointsPerBottle, bool player1Starting) {
    //reset or new game
    _player1Starting = player1Starting;

    _player1 = Player.initial(
        capseur1, true, bottlesNumber, pointsPerBottle, _player1Starting);
    _player2 = Player.initial(
        capseur2, false, bottlesNumber, pointsPerBottle, !_player1Starting);
    _reverseCount = 0;
    _pointsRequired = pointsPerBottle * bottlesNumber;
    _pointsPerBottle = pointsPerBottle;
    _context = context;
  }

  Game(this._player1, this._player2, this._reverseCount, this._pointsRequired,
      this._pointsPerBottle, this._player1Starting);

  BuildContext get context => _context;
  Player get player1 => _player1;
  Player get player2 => _player2;
  int get reverseCount => _reverseCount;
  int get pointsRequired => _pointsRequired;
  int get pointsPerBottle => _pointsPerBottle;
  bool get player1starting => _player1Starting;

  setContext(BuildContext context) {
    _context = context;
  }

  setReverseCount(int value) {
    _reverseCount = value;
  }

  static Future<void> startMatch(
      BuildContext context, String title, Capseur capseur,
      {Capseur capseur2}) async {
    final _bottlesNumberKey = GlobalKey<_DropDownAlertState>();
    final _pointsPerBottleKey = GlobalKey<_DropDownAlertState>();

    DropDownAlert bottlesNumberDialog = new DropDownAlert(
      key: _bottlesNumberKey,
      initialValue: 3,
      values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
    );
    DropDownAlert pointsPerBottleDialog = new DropDownAlert(
      key: _pointsPerBottleKey,
      initialValue: 4,
      values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    );

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogNewMatch(
              title: title,
              capseur: capseur,
              bottlesNumberKey: _bottlesNumberKey,
              pointsPerBottleKey: _pointsPerBottleKey,
              bottlesNumberDialog: bottlesNumberDialog,
              pointsPerBottleDialog: pointsPerBottleDialog,
              capseur2: capseur2);
        });
  }

  nextTurn(bool capsHit) {
    if (capsHit) {
      if (_player1.playing) {
        this.player1.addCapsThrow();
        this.player1.addCapsHit();
      } else {
        this.player2.addCapsThrow();
        this.player2.addCapsHit();
      }
      setReverseCount(this.reverseCount + 1);
    } else {
      if (this.reverseCount > 0) {
        if (_player1.playing) {
          this.player1.addCapsThrow();
          setScoreAndDrink(this.reverseCount, this.player1, this.player2);
        } else {
          this.player2.addCapsThrow();
          setScoreAndDrink(this.reverseCount, this.player2, this.player1);
        }

        setReverseCount(0);
      }
    }
    switchTurns();
  }

  void switchTurns() {
    _player1.setPlaying(!_player1.playing);
    _player2.setPlaying(!_player2.playing);
  }

  void setScoreAndDrink(int currentReverseCount, Player playerWhoDrinks,
      Player playerWhoseScoreIncrease) {
    playerWhoseScoreIncrease
        .setScore(playerWhoseScoreIncrease.score + currentReverseCount);
    playerWhoDrinks.drink(currentReverseCount, this.pointsPerBottle);
    if (playerWhoseScoreIncrease.score >= this.pointsRequired) {
      //endGame(playerWhoseScoreIncrease);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return endGamePopUp(playerWhoseScoreIncrease);
        },
      );
    }
  }

  WillPopScope endGamePopUp(Player winner) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Container(
          height: 350.0,
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 80,
              ),
              Text(
                winner.capseur.username + ' vainqueur !',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(this.player2.capseur.username,
                        style: TextStyle(
                            color: this.player2 == winner
                                ? kPrimaryColor
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w300)),
                    Text(' - '),
                    Text(this.player1.capseur.username,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: this.player2 == winner
                                ? Colors.black
                                : kPrimaryColor)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.player2.score.toString() +
                    ' - ' +
                    this.player1.score.toString(),
                style: TextStyle(fontFamily: 'PirataOne', fontSize: 30),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  child: Text(
                    "Valider",
                    style: TextStyle(color: kWhiteColor),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    endGame(winner);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  endGame(Player winner) {
    /* UPDATE ALL THE VARIABLES OF BOTH CAPSEURS IN THE SERVER */
    DatabaseService().updateMatchWaitingToBeValidatedData(
        this.player1.capseur.uid,
        this.player2.capseur.uid,
        this.player1.score,
        this.player2.score,
        this.pointsRequired,
        this.pointsPerBottle,
        this.player1.capsHitInThisGame,
        this.player1.capsThrowInThisGame,
        this.player2.capsHitInThisGame,
        this.player2.capsThrowInThisGame);

    Navigator.of(this.context).pop();
    Navigator.of(this.context).pop();
  }
}

class DropDownAlert extends StatefulWidget {
  DropDownAlert({Key key, this.values, this.initialValue}) : super(key: key);

  final List<int> values;
  final int initialValue;

  @override
  _DropDownAlertState createState() => _DropDownAlertState();
}

class _DropDownAlertState extends State<DropDownAlert> {
  int _value;
  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _value,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (int newValue) {
        setState(() {
          _value = newValue;
        });
      },
      items: widget.values.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}

class AlertDialogNewMatch extends StatefulWidget {
  AlertDialogNewMatch(
      {Key key,
      this.title,
      this.capseur,
      this.bottlesNumberKey,
      this.pointsPerBottleKey,
      this.bottlesNumberDialog,
      this.pointsPerBottleDialog,
      this.capseur2})
      : super(key: key);

  final String title;
  final Capseur capseur;
  final Capseur capseur2;
  final GlobalKey<_DropDownAlertState> bottlesNumberKey;
  final GlobalKey<_DropDownAlertState> pointsPerBottleKey;
  final DropDownAlert bottlesNumberDialog;
  final DropDownAlert pointsPerBottleDialog;

  @override
  _AlertDialogNewMatchState createState() => _AlertDialogNewMatchState();
}

class _AlertDialogNewMatchState extends State<AlertDialogNewMatch> {
  Capseur opponent;
  bool showingHelp;

  void _showUserList({Function selectOpponent}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamProvider<List<Capseur>>.value(
              value: DatabaseService().capseurs,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: RankingList(onPressed: selectOpponent),
              ));
        });
  }

  int getBottlesNumber() => widget.bottlesNumberKey.currentState._value;
  int getPointsPerBottle() => widget.pointsPerBottleKey.currentState._value;

  @override
  void initState() {
    opponent = widget.capseur2 ?? null;
    showingHelp = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Center(
        child: Text(widget.title),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            if (opponent != null) Text("Contre: " + opponent.username),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Selectionne ton adversaire",
                style: TextStyle(color: kWhiteColor),
              ),
              color: (opponent != null) ? kSecondaryColor : kPrimaryColor,
              onPressed: () {
                _showUserList(selectOpponent: (Capseur _opponent) {
                  if (_opponent.uid != widget.capseur.uid) {
                    setState(() {
                      opponent = _opponent;
                    });
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Nombre de kros:"), widget.bottlesNumberDialog],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Points par kros"),
                IconButton(
                    icon: Icon(
                      showingHelp ? Icons.keyboard_arrow_up : Icons.help,
                      color: kSecondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        showingHelp = !showingHelp;
                      });
                    }),
                widget.pointsPerBottleDialog
              ],
            ),
            if (showingHelp)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey[100]),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  "Par exemple, si vous choisissez 4 points par kro, à chaque fois qu'un joueur gagne un point, le joueur adverse doit boire un quart de sa kro. Et donc au bout de 4 points, le joueur doit finir sa kro et en entamer une autre.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              onPressed: () async {
                if (opponent != null) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new RandomPickStartPage(
                            title: widget.title,
                            capseur2: widget.capseur,
                            capseur1: opponent,
                            bottlesNumber: getBottlesNumber(),
                            pointsPerBottle: getPointsPerBottle())),
                  );
                }
              },
              child: Text(
                "Jouer",
                style: TextStyle(color: kWhiteColor),
              ),
              color: (opponent != null) ? kPrimaryColor : kPrimaryDisableColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('ou', style: TextStyle(color: Colors.grey[400], fontSize: 15.0),),
            ),
            TextButton(
              onPressed: () async {
                if (opponent != null) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new RandomPickStartPage(
                            title: widget.title,
                            capseur2: widget.capseur,
                            capseur1: opponent,
                            bottlesNumber: getBottlesNumber(),
                            pointsPerBottle: getPointsPerBottle())),
                  );
                }
              },
              child: Text(
                "Rentrer le score manuellement",
                style: TextStyle(color: kSecondaryColor.withOpacity((opponent != null) ? 1 : 0.5)),
              ),
              //color: (opponent != null) ? kPrimaryColor : kPrimaryDisableColor,
            )
          ],
        ),
      ),
    );
  }
}
