import 'dart:async';
import 'dart:math';

import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/data.dart';
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
    Capseur winner;
    Capseur loser;
    if (this.player1.score > this.player2.score) {
      winner = capseur1;
      loser = capseur2;
    } else {
      winner = capseur2;
      loser = capseur1;
    }

    DatabaseService().updateCapseurData(
        capseur1.uid,
        capseur1.firstname,
        capseur1.lastname,
        capseur1.matchsPlayed + 1,
        capseur1.matchsWon + (this.player1.score > this.player2.score ? 1 : 0),
        capseur1.capsHit + this.player1.capsHitInThisGame,
        capseur1.bottlesEmptied + this.player2.score ~/ this.pointsPerBottle,
        capseur1.points +
            (this.player1.score > this.player2.score
                ? updatePointsWinner(winner, loser)
                : updatePointsloser(winner, loser)));
    DatabaseService().updateCapseurData(
        capseur2.uid,
        capseur2.firstname,
        capseur2.lastname,
        capseur2.matchsPlayed + 1,
        capseur2.matchsWon + (this.player2.score > this.player1.score ? 1 : 0),
        capseur2.capsHit + this.player2.capsHitInThisGame,
        capseur2.bottlesEmptied + this.player1.score ~/ this.pointsPerBottle,
        capseur2.points +
            (this.player2.score > this.player1.score
                ? updatePointsWinner(winner, loser)
                : updatePointsloser(winner, loser)));
    Navigator.of(this.context).pop();
    Navigator.of(this.context).pop();
  }

  double updatePointsWinner(Capseur winner, Capseur loser) {
    double gapPointsATP = loser.points - winner.points;
    double addToWinner = theWinningAlgo(gapPointsATP);
    double reliabilityCoeff = theBonusAlgo(this.pointsRequired);
    return addToWinner * reliabilityCoeff;
  }

  double updatePointsloser(Capseur winner, Capseur loser) {
    double gapPointsATP = loser.points - winner.points;
    double removeToLoser = theLoosingAlgo(gapPointsATP);
    double reliabilityCoeff = theBonusAlgo(this.pointsRequired);
    return - removeToLoser * reliabilityCoeff;
  }

  double theWinningAlgo(double gapATP) {
    if (gapATP < -100) {
      return 1;
    } else if (-100 <= gapATP && gapATP < -50) {
      return 1 / 50 * gapATP + 3;
    } else if (-50 <= gapATP && gapATP < 0) {
      return 3 / 50 * gapATP + 5;
    } else if (0 <= gapATP && gapATP < 50) {
      return 15 / 50 * gapATP + 5;
    } else if (50 <= gapATP && gapATP < 100) {
      return 10 / 50 * gapATP + 10;
    } else {
      return pow(gapATP, 1 / 200) * log(gapATP - 97) + 29.5;
    }
  }

  double theLoosingAlgo(double gapATP) {
    return theWinningAlgo(gapATP) * 0.8;
  }

  double theBonusAlgo(int pointsRequired) {
    //correspond to the coefficient of reliability. If the game is played in 4 points it doesn't have the same importance than a game played in 16 points (coeff 1) or in 32 (coeff 2)
    if (4 <= pointsRequired && pointsRequired < 32) {
      return 1 / 16 * pointsRequired;
    } else {
      return 2;
    }
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

class AlertDialogNewMatch extends StatefulWidget {
  AlertDialogNewMatch(
      {Key key,
      this.title,
      this.capseur,
      this.bottlesNumberKey,
      this.pointsPerBottleKey,
      this.bottlesNumberDialog,
      this.pointsPerBottleDialog})
      : super(key: key);

  final String title;
  final Capseur capseur;
  final GlobalKey<_DropDownAlertState> bottlesNumberKey;
  final GlobalKey<_DropDownAlertState> pointsPerBottleKey;
  final DropDownAlert bottlesNumberDialog;
  final DropDownAlert pointsPerBottleDialog;

  @override
  _AlertDialogNewMatchState createState() => _AlertDialogNewMatchState();
}

class _AlertDialogNewMatchState extends State<AlertDialogNewMatch> {
  Capseur opponent;

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
  Widget build(BuildContext context) {
    return AlertDialog(
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
            Text(opponent != null
                ? ("Contre: " + opponent.firstname + ' ' + opponent.lastname)
                : ""),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Selectionne ton adversaire",
                style: TextStyle(color: kWhiteColor),
              ),
              color: kSecondaryColor,
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
              children: [Text("Points par kro:"), widget.pointsPerBottleDialog],
            ),
            SizedBox(
              height: 40,
            ),
            /* Validation button */
            RaisedButton(
              onPressed: () async {
                if (opponent != null) {
                  //Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new MatchPage(
                            title: widget.title,
                            capseur1: widget.capseur,
                            capseur2: opponent,
                            bottlesNumber: getBottlesNumber(),
                            pointsPerBottle: getPointsPerBottle())),
                  );
                }
              },
              child: Text(
                "Valider",
                style: TextStyle(color: kWhiteColor),
              ),
              color: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
