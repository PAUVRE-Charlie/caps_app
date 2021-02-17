import 'dart:math';

import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data.dart';
import 'matchResults.dart';

class ValidateMatch extends StatefulWidget {
  ValidateMatch(this.capseurs, this.matchWaitingToBeValidated, {Key key})
      : super(key: key);

  final List<Capseur> capseurs;
  final MatchWaitingToBeValidated matchWaitingToBeValidated;

  @override
  _ValidateMatchState createState() => _ValidateMatchState();
}

class _ValidateMatchState extends State<ValidateMatch> {
  void updateCapseursStats(
      MatchWaitingToBeValidated match, Capseur capseur1, Capseur capseur2) {
    Capseur winner;
    Capseur loser;
    if (match.scorePlayer1 > match.scorePlayer2) {
      winner = capseur1;
      loser = capseur2;
    } else {
      winner = capseur2;
      loser = capseur1;
    }

    DatabaseService().updateCapseurData(
        capseur1.uid,
        capseur1.username,
        capseur1.matchsPlayed + 1,
        capseur1.matchsWon + (match.scorePlayer1 > match.scorePlayer2 ? 1 : 0),
        capseur1.capsHit + match.player1CapsHitInThisGame,
        capseur1.capsThrow + match.player1CapsThrowInThisGame,
        capseur1.bottlesEmptied + match.scorePlayer2 ~/ match.pointsPerBottle,
        capseur1.points +
            (match.scorePlayer1 > match.scorePlayer2
                ? updatePointsWinner(winner, loser, match.pointsRequired)
                : updatePointsloser(winner, loser, match.pointsRequired)));

    DatabaseService().updateCapseurData(
        capseur2.uid,
        capseur2.username,
        capseur2.matchsPlayed + 1,
        capseur2.matchsWon + (match.scorePlayer2 > match.scorePlayer1 ? 1 : 0),
        capseur2.capsHit + match.player2CapsHitInThisGame,
        capseur2.capsThrow + match.player2CapsThrowInThisGame,
        capseur2.bottlesEmptied + match.scorePlayer1 ~/ match.pointsPerBottle,
        capseur2.points +
            (match.scorePlayer2 > match.scorePlayer1
                ? updatePointsWinner(winner, loser, match.pointsRequired)
                : updatePointsloser(winner, loser, match.pointsRequired)));
  }

  double updatePointsWinner(Capseur winner, Capseur loser, int pointsRequired) {
    double gapPointsATP = loser.points - winner.points;
    double addToWinner = theWinningAlgo(gapPointsATP);
    double reliabilityCoeff = theBonusAlgo(pointsRequired);
    return addToWinner * reliabilityCoeff;
  }

  double updatePointsloser(Capseur winner, Capseur loser, int pointsRequired) {
    double gapPointsATP = loser.points - winner.points;
    double removeToLoser = theLoosingAlgo(gapPointsATP);
    double reliabilityCoeff = theBonusAlgo(pointsRequired);
    return -removeToLoser * reliabilityCoeff;
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
    if (pointsRequired < 4) {
      return 0.25;
    } else if (4 <= pointsRequired && pointsRequired < 32) {
      return 1 / 16 * pointsRequired;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Si vous avez joué ce match, appuyez sur ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "NotoSansJP"),
                children: [
                  TextSpan(
                    text: "VALIDER",
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: "PirataOne",
                        fontSize: 20),
                  ),
                  TextSpan(text: ", sinon appuyer sur "),
                  TextSpan(
                    text: "REFUSER",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: "PirataOne",
                        fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          MatchResults(
            match: new MatchEnded(
                widget.matchWaitingToBeValidated.uid,
                widget.matchWaitingToBeValidated.player1,
                widget.matchWaitingToBeValidated.player2,
                widget.matchWaitingToBeValidated.date,
                widget.matchWaitingToBeValidated.scorePlayer1,
                widget.matchWaitingToBeValidated.scorePlayer2),
            capseurs: widget.capseurs,
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      updateCapseursStats(
                          widget.matchWaitingToBeValidated,
                          widget.capseurs.firstWhere((capseur) =>
                              capseur.uid ==
                              widget.matchWaitingToBeValidated.player1),
                          widget.capseurs.firstWhere((capseur) =>
                              capseur.uid ==
                              widget.matchWaitingToBeValidated.player2));

                      if (widget.matchWaitingToBeValidated.tournamentUid !=
                          null) {
                        Uuid uuid = Uuid();
                        String matchUid = uuid.v4();
                        DatabaseService().updateMatchData(
                            widget.matchWaitingToBeValidated.player1,
                            widget.matchWaitingToBeValidated.player2,
                            widget.matchWaitingToBeValidated.scorePlayer1,
                            widget.matchWaitingToBeValidated.scorePlayer2,
                            matchUid: matchUid);
                        DatabaseService().updateMatchOfTournamentData(matchUid,
                            widget.matchWaitingToBeValidated.tournamentUid,
                            poolUid: widget.matchWaitingToBeValidated.poolUid,
                            finalBoardPosition: widget
                                .matchWaitingToBeValidated.finalBoardPosition);
                      } else {
                        DatabaseService().updateMatchData(
                            widget.matchWaitingToBeValidated.player1,
                            widget.matchWaitingToBeValidated.player2,
                            widget.matchWaitingToBeValidated.scorePlayer1,
                            widget.matchWaitingToBeValidated.scorePlayer2);
                      }
                      DatabaseService().deleteMatchWaitingToBeValidated(
                          widget.matchWaitingToBeValidated.uid);
                    },
                    color: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: kWhiteColor,
                    ),
                  ),
                  Text(
                    "VALIDER",
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: "PirataOne",
                        fontSize: 20),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      DatabaseService().deleteMatchWaitingToBeValidated(
                          widget.matchWaitingToBeValidated.uid);
                    },
                    color: kPrimaryColor,
                    child: Icon(
                      Icons.cancel,
                      color: kWhiteColor,
                    ),
                  ),
                  Text(
                    "REFUSER",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: "PirataOne",
                        fontSize: 20),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }
}
