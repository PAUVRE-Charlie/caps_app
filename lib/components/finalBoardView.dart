import 'dart:math';

import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
import 'package:caps_app/components/loading.dart';
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
    final matchsWaitingToBeValidated =
        Provider.of<List<MatchWaitingToBeValidated>>(context);

    if (matchsWaitingToBeValidated == null) return LoadingWidget();

    if (!widget.tournament.poolsClosed)
      return Center(
          child: Text(
        "Encore en phase de poules",
        style: TextStyle(
            fontFamily: 'PirataOne', fontSize: 35, color: Colors.black),
      ));

    const double heightSpace = 20;

    return BidirectionalScrollViewPlugin(
      child: Row(
        children: [
          for (int j = widget.tournament.finalBoard.maxMatchs; j >= 0; j--)
            Column(
              children: [
                SizedBox(
                  height:
                      (pow(2, widget.tournament.finalBoard.maxMatchs - j) - 1)
                              .toDouble() *
                          heightSpace,
                ),
                for (int i = pow(2, j); i < pow(2, j + 1); i++) ...[
                  Row(
                    children: [
                      if (j != widget.tournament.finalBoard.maxMatchs) ...[
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            CustomPaint(
                              painter: LinePainter(
                                  -50,
                                  (pow(
                                                  2,
                                                  widget.tournament.finalBoard
                                                          .maxMatchs -
                                                      j) -
                                              1) /
                                          2.toDouble() *
                                          heightSpace +
                                      heightSpace / 2),
                            ),
                            CustomPaint(
                              painter: LinePainter(
                                  -50,
                                  -(pow(
                                                  2,
                                                  widget.tournament.finalBoard
                                                          .maxMatchs -
                                                      j) -
                                              1) /
                                          2.toDouble() *
                                          heightSpace -
                                      heightSpace / 2),
                            ),
                          ],
                        )
                      ],
                      Container(
                          height: heightSpace,
                          child: CaseOfFinalBoard(
                            tournament: widget.tournament,
                            capseurs: widget.capseurs,
                            position: i,
                            matchsWaitingToBeValidated:
                                matchsWaitingToBeValidated,
                          ))
                    ],
                  ),
                  if (i != pow(2, j + 1) - 1)
                    SizedBox(
                      height: (pow(
                                      2,
                                      widget.tournament.finalBoard.maxMatchs -
                                          j +
                                          1) -
                                  1)
                              .toDouble() *
                          heightSpace,
                    ),
                ],
                SizedBox(
                  height:
                      (pow(2, widget.tournament.finalBoard.maxMatchs - j) - 1)
                              .toDouble() *
                          heightSpace,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CaseOfFinalBoard extends StatelessWidget {
  const CaseOfFinalBoard(
      {Key key,
      @required this.tournament,
      @required this.capseurs,
      @required this.position,
      @required this.matchsWaitingToBeValidated})
      : super(key: key);

  final Tournament tournament;
  final List<Capseur> capseurs;
  final List<MatchWaitingToBeValidated> matchsWaitingToBeValidated;
  final int position;

  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);

    Participant participantOfThisCase =
        tournament.finalBoard.getParticipantAt(position);

    bool isAlreadyPlayed() {
      for (MatchWaitingToBeValidated match in matchsWaitingToBeValidated.where(
          (match) => match.tournamentUid == tournament.tournamentInfo.uid)) {
        if (match.finalBoardPosition == position) return true;
      }
      return false;
    }

    return Container(
      width: 100,
      child: Center(
        child: participantOfThisCase != null
            ? TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                child: Text(participantOfThisCase.getCapseur(capseurs).username,
                    style: TextStyle(
                        color: participantOfThisCase.capseurUid == user.uid
                            ? kPrimaryColor
                            : Colors.black)),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ProfilePage(
                          capseur: participantOfThisCase.getCapseur(capseurs)),
                    ),
                  );
                },
              )
            : tournament.finalBoard.playInThisMatch(user.uid, position) &&
                    tournament.finalBoard.participantsInMatch(position).first !=
                        null &&
                    tournament.finalBoard.participantsInMatch(position).last !=
                        null
                ? TextButton(
                    child: Text(
                      isAlreadyPlayed() ? 'A valider...' : 'Jouer',
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                    onPressed: !isAlreadyPlayed()
                        ? () {
                            List<Participant> participantsInMatch = tournament
                                .finalBoard
                                .participantsInMatch(position);
                            Game.startMatchOfTournament(
                              context,
                              "Match",
                              capseurs.firstWhere((capseur) =>
                                  capseur.uid ==
                                  participantsInMatch
                                      .firstWhere((participant) =>
                                          participant.capseurUid == user.uid)
                                      .capseurUid),
                              tournament.tournamentInfo.uid,
                              finalBoardPosition: position,
                              capseur2: capseurs.firstWhere((capseur) =>
                                  capseur.uid ==
                                  participantsInMatch
                                      .firstWhere((participant) =>
                                          participant.capseurUid != user.uid)
                                      .capseurUid),
                            );
                          }
                        : null)
                : Text('  -------'),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double x;
  final double y;

  LinePainter(this.x, this.y);

  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(0, 0),
        Offset(x, y),
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..strokeWidth = 2);
  }

  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
