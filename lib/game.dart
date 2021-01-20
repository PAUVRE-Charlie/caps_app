import 'dart:async';
import 'dart:math';

import 'package:caps_app/pages/matchPage.dart';
import 'package:caps_app/player.dart';
import 'package:flutter/material.dart';

import 'capseur.dart';

class Game {
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
  }

  Game(this._player1, this._player2, this._reverseCount, this._pointsRequired,
      this._pointsPerBottle);

  Player get player1 => _player1;
  Player get player2 => _player2;
  int get reverseCount => _reverseCount;
  int get pointsRequired => _pointsRequired;
  int get pointsPerBottle => _pointsPerBottle;

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
    print("${winner.capseur.firstname} won");
    /* UPDATE ALL THE VARIABLES OF BOTH CAPSEURS IN THE SERVER */
  }

  nextTurn(bool capsHit) {
    if (capsHit) {
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

    GlobalKey<_DropDownAlertState> bottlesNumberKey =
        new GlobalKey<_DropDownAlertState>();
    GlobalKey<_DropDownAlertState> pointsPerBottleKey =
        new GlobalKey<_DropDownAlertState>();

    DropDownAlert bottlesNumberDialog = new DropDownAlert(
      key: bottlesNumberKey,
      initialValue: 3,
      values: values,
    );
    DropDownAlert pointsPerBottleDialog = new DropDownAlert(
      key: pointsPerBottleKey,
      initialValue: 4,
      values: values,
    );

    int getBottlesNumber() => bottlesNumberKey.currentState._value;
    int getPointsPerBottle() => pointsPerBottleKey.currentState._value;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Selectionne ton adversaire"),
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
                      Capseur capseur2 = Capseur(
                          'Pierre', 'Schmutz', 2, 156, 136, 589, 241, 'b');
                      //Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new MatchPage(
                                title: title,
                                capseur1: capseur,
                                capseur2: capseur2,
                                bottlesNumber: getBottlesNumber(),
                                pointsPerBottle: getPointsPerBottle())),
                      );
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
