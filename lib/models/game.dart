import 'dart:async';
import 'dart:math';

import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/pages/matchPage.dart';
import 'package:caps_app/models/player.dart';
import 'package:caps_app/services/database.dart';
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

  Game.initial(Capseur capseur1, Capseur capseur2, int bottlesNumber,
      int pointsPerBottle) {
    //reset or new game
    bool player1starting = Random().nextBool();

    _player1 = Player.initial(
        capseur1, true, bottlesNumber, pointsPerBottle, player1starting);
    _player2 = Player.initial(
        capseur2, false, bottlesNumber, pointsPerBottle, !player1starting);
    _reverseCount = 0;
    _pointsRequired = pointsPerBottle * bottlesNumber;
    _pointsPerBottle = pointsPerBottle;
    _context = context;
  }

  Game(this._player1, this._player2, this._reverseCount, this._pointsRequired,
      this._pointsPerBottle);

  BuildContext get context => _context;
  Player get player1 => _player1;
  Player get player2 => _player2;
  int get reverseCount => _reverseCount;
  int get pointsRequired => _pointsRequired;
  int get pointsPerBottle => _pointsPerBottle;

  setContext(BuildContext context) {
    _context = context;
  }

  setReverseCount(int value) {
    _reverseCount = value;
  }

  setScoreAndDrink(int currentReverseCount, Player playerWhoDrinks,
      Player playerWhoseScoreIncrease) {
    playerWhoseScoreIncrease
        .setScore(playerWhoseScoreIncrease.score + currentReverseCount);
    playerWhoDrinks.drink(currentReverseCount, this.pointsPerBottle);
    if (playerWhoseScoreIncrease.score >= this.pointsRequired) {
      endGame(playerWhoseScoreIncrease);
    }
  }

  endGame(Player winner) {
    /* UPDATE ALL THE VARIABLES OF BOTH CAPSEURS IN THE SERVER */
    DatabaseService().updateMatchData(this.player1.capseur.uid,
        this.player2.capseur.uid, this.player1.score, this.player2.score);
    Capseur capseur1 = this.player1.capseur;
    Capseur capseur2 = this.player2.capseur;
    DatabaseService().updateCapseurData(
        capseur1.uid,
        capseur1.firstname,
        capseur1.lastname,
        capseur1.rank,
        capseur1.matchsPlayed + 1,
        capseur1.matchsWon + (this.player1.score > this.player2.score ? 1 : 0),
        capseur1.capsHit + this.player1.capsHitInThisGame,
        capseur1.bottlesEmptied + this.player2.score ~/ this.pointsPerBottle);
    DatabaseService().updateCapseurData(
        capseur2.uid,
        capseur2.firstname,
        capseur2.lastname,
        capseur2.rank,
        capseur2.matchsPlayed + 1,
        capseur2.matchsWon + (this.player2.score > this.player1.score ? 1 : 0),
        capseur2.capsHit + this.player2.capsHitInThisGame,
        capseur2.bottlesEmptied + this.player1.score ~/ this.pointsPerBottle);
    Navigator.of(this.context).pop();
    Navigator.of(this.context).pop();
  }

  nextTurn(bool capsHit) {
    if (capsHit) {
      if (_player1.playing)
        this.player1.addCapsHit();
      else
        this.player2.addCapsHit();
      setReverseCount(this.reverseCount + 1);
    } else {
      if (this.reverseCount > 0) {
        if (_player1.playing) {
          setScoreAndDrink(this.reverseCount, this.player1, this.player2);
        } else {
          setScoreAndDrink(this.reverseCount, this.player2, this.player1);
        }
        setReverseCount(0);
      }
    }
    // Switch turn
    _player1.setPlaying(!_player1.playing);
    _player2.setPlaying(!_player2.playing);
  }

  static Future<void> startMatch(
      BuildContext context, String title, Capseur capseur) async {
    List<int> values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    final _bottlesNumberKey = GlobalKey<_DropDownAlertState>();
    final _pointsPerBottleKey = GlobalKey<_DropDownAlertState>();

    DropDownAlert bottlesNumberDialog = new DropDownAlert(
      key: _bottlesNumberKey,
      initialValue: 3,
      values: values,
    );
    DropDownAlert pointsPerBottleDialog = new DropDownAlert(
      key: _pointsPerBottleKey,
      initialValue: 4,
      values: values,
    );

    int getBottlesNumber() => _bottlesNumberKey.currentState._value;
    int getPointsPerBottle() => _pointsPerBottleKey.currentState._value;

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

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          Capseur opponent;

          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: Text("Selectionne ton adversaire"),
                    onPressed: () {
                      _showUserList(selectOpponent: (Capseur _opponent) {
                        if (_opponent.uid != capseur.uid) {
                          opponent = _opponent;
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Nombre de kros:"), bottlesNumberDialog],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Points par kro:"), pointsPerBottleDialog],
                  ),
                  /* Validation button */
                  FlatButton(
                    onPressed: () async {
                      if (opponent != null) {
                        //Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (ctxt) => new MatchPage(
                                  title: title,
                                  capseur1: capseur,
                                  capseur2: opponent,
                                  bottlesNumber: getBottlesNumber(),
                                  pointsPerBottle: getPointsPerBottle())),
                        );
                      }
                    },
                    child: Text("validate"),
                  )
                ],
              ),
            ),
          );
        });
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
