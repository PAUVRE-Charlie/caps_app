import 'dart:math';

import 'package:caps_app/components/matchsWaitingList.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/game.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinalBoardView extends StatefulWidget {
  FinalBoardView({Key key, @required this.tournament, @required this.capseurs})
      : super(key: key);

  final Tournament tournament;
  final List<Capseur> capseurs;

  @override
  _PoolsViewState createState() => _PoolsViewState();
}

class _PoolsViewState extends State<FinalBoardView> {
  @override
  Widget build(BuildContext context) {
    if (widget.tournament.finalBoard.numberOfPlayers == 0)
      return Text("Encore en phases de poules");

    const double heightSpace = 40;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int j = widget.tournament.finalBoard.maxMatchs; j >= 0; j--)
                Column(
                  children: [
                    SizedBox(
                      height:
                          (pow(2, widget.tournament.finalBoard.maxMatchs - j) -
                                      1)
                                  .toDouble() *
                              heightSpace,
                    ),
                    for (int i = pow(2, j); i < pow(2, j + 1); i++) ...[
                      Container(
                          height: heightSpace,
                          child: CaseOfFinalBoard(
                            tournament: widget.tournament,
                            capseurs: widget.capseurs,
                            position: i,
                          )),
                      if (i != pow(2, j + 1) - 1)
                        SizedBox(
                          height: (pow(
                                          2,
                                          widget.tournament.finalBoard
                                                  .maxMatchs -
                                              j +
                                              1) -
                                      1)
                                  .toDouble() *
                              heightSpace,
                        ),
                    ],
                    SizedBox(
                      height:
                          (pow(2, widget.tournament.finalBoard.maxMatchs - j) -
                                      1)
                                  .toDouble() *
                              heightSpace,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CaseOfFinalBoard extends StatefulWidget {
  const CaseOfFinalBoard(
      {Key key,
      @required this.tournament,
      @required this.capseurs,
      @required this.position})
      : super(key: key);

  @override
  _CaseOfFinalBoardState createState() => _CaseOfFinalBoardState();

  final Tournament tournament;
  final List<Capseur> capseurs;
  final int position;
}

class _CaseOfFinalBoardState extends State<CaseOfFinalBoard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);
    final matchsWaitingToBeValidated =
        Provider.of<List<MatchWaitingToBeValidated>>(context);

    Participant participantOfThisCase =
        widget.tournament.finalBoard.getParticipantAt(widget.position);

    bool isAlreadyPlayed() {
      for (MatchWaitingToBeValidated match in matchsWaitingToBeValidated) {
        if (match.finalBoardPosition == widget.position) return true;
      }
      return false;
    }

    return Center(
      child: participantOfThisCase != null
          ? TextButton(
              child: Text(
                  participantOfThisCase.getCapseur(widget.capseurs).username,
                  style: TextStyle(
                      color: participantOfThisCase.capseurUid == user.uid
                          ? kPrimaryColor
                          : Colors.black)),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ProfilePage(
                        capseur:
                            participantOfThisCase.getCapseur(widget.capseurs)),
                  ),
                );
              },
            )
          : widget.tournament.finalBoard
                      .playInThisMatch(user.uid, widget.position) &&
                  widget.tournament.finalBoard
                          .participantsInMatch(widget.position)
                          .first !=
                      null &&
                  widget.tournament.finalBoard
                          .participantsInMatch(widget.position)
                          .last !=
                      null
              ? TextButton(
                  child: Text(isAlreadyPlayed() ? 'A valider...' : 'Jouer'),
                  onPressed: !isAlreadyPlayed()
                      ? () {
                          List<Participant> participantsInMatch = widget
                              .tournament.finalBoard
                              .participantsInMatch(widget.position);
                          Game.startMatchOfTournament(
                            context,
                            "Match",
                            widget.capseurs.firstWhere((capseur) =>
                                capseur.uid ==
                                participantsInMatch
                                    .firstWhere((participant) =>
                                        participant.capseurUid == user.uid)
                                    .capseurUid),
                            widget.tournament.tournamentInfo.uid,
                            finalBoardPosition: widget.position,
                            capseur2: widget.capseurs.firstWhere((capseur) =>
                                capseur.uid ==
                                participantsInMatch
                                    .firstWhere((participant) =>
                                        participant.capseurUid != user.uid)
                                    .capseurUid),
                          );
                        }
                      : null)
              : Text('-------'),
    );
  }
}
