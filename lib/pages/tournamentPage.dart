import 'dart:math';

import 'package:caps_app/components/TournamentView.dart';
import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/tournamentsList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class TournamentPage extends StatelessWidget {
  final TournamentInfo tournamentInfo;

  TournamentPage({Key key, @required this.tournamentInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var matchsOfTournaments = Provider.of<List<MatchOfTournament>>(context);
    var matchs = Provider.of<List<MatchEnded>>(context);
    var pools = Provider.of<List<Pool>>(context);
    var capseurs = Provider.of<List<Capseur>>(context);
    var capseursInTournaments =
        Provider.of<Map<String, List<Participant>>>(context);

    Widget widgetToShow;

    if (capseurs == null ||
        matchs == null ||
        matchsOfTournaments == null ||
        capseursInTournaments == null ||
        pools == null) {
      widgetToShow = new LoadingWidget();
    } else {
      // filter all matchs and pools to only keep the ones of this tournament
      matchsOfTournaments = matchsOfTournaments
          .where((match) => match.tournamentUid == tournamentInfo.uid)
          .toList();

      matchs = matchs.where((match) {
        for (MatchOfTournament matchOfTournament in matchsOfTournaments) {
          if (matchOfTournament.match == match.uid) return true;
        }
        return false;
      }).toList();

      pools = pools
          .where((pool) => pool.tournamentUid == tournamentInfo.uid)
          .toList();

      pools.forEach((pool) {
        pool.reset();
      });

      // create the tournament
      Tournament tournament =
          new Tournament(tournamentInfo, pools, matchsOfTournaments, matchs);

      // put the participants in the right pool and the right position in the final board
      List<Participant> tournamentAssociation =
          capseursInTournaments[tournamentInfo.uid];

      while (tournamentAssociation == null) widgetToShow = LoadingWidget();
      tournamentAssociation.forEach((participant) {
        if (participant.poolUid != '') {
          pools
              .firstWhere((pool) => pool.uid == participant.poolUid)
              .addParticipant(participant);
        }
        if (participant.finalBoardPosition != 0) {
          tournament.finalBoard.addParticipant(participant);
        }
      });

      // put all matchs in correponding pool/finalboard
      matchsOfTournaments.forEach((matchofTournament) {
        if (matchofTournament.poolUid != '') {
          pools
              .firstWhere((pool) => pool.uid == matchofTournament.poolUid)
              .addMatch(matchofTournament);
        }
        if (matchofTournament.finalBoardPosition != 0) {
          tournament.finalBoard.addParticipant(new Participant.initial(
              matchs
                  .firstWhere((match) => match.uid == matchofTournament.match)
                  .winnerUid,
              '',
              matchofTournament.finalBoardPosition));
        }
      });

      // complete the profile of the participant for this tournament using the matchs
      if (pools.isNotEmpty) {
        for (Pool pool in pools) {
          // complete its stats in his pool
          for (MatchOfTournament matchOfTournament in pool.matchs) {
            MatchEnded match = matchs
                .firstWhere((match) => match.uid == matchOfTournament.match);

            Participant participant1 = pool.participants.firstWhere(
                (participant) => participant.capseurUid == match.player1);
            Participant participant2 = pool.participants.firstWhere(
                (participant) => participant.capseurUid == match.player2);

            int capsAverageForParticipant1 =
                match.scorePlayer1 - match.scorePlayer2;

            participant1.addCapsAverage(capsAverageForParticipant1);
            participant2.addCapsAverage(-capsAverageForParticipant1);
          }
          if (pool.closed &&
              pool.rankedPartipant.first.finalBoardPosition == 0) {
            for (int i = 0;
                i < tournament.tournamentInfo.numberPlayersGettingOutOfEachPool;
                i++) {
              Participant participant = pool.rankedPartipant[i];
              bool playerPutInFinalBoard = false;
              int j = tournament.finalBoard.numberOfCasesOnFirstColumn;
              while (!playerPutInFinalBoard) {
                if (tournament.finalBoard.getParticipantAt(j) == null) {
                  playerPutInFinalBoard = true;

                  DatabaseService().updateExistingCapseursInTournamentsData(
                      participant.associationUid,
                      tournament.tournamentInfo.uid,
                      pool.uid,
                      participant.capseurUid,
                      j);
                } else {
                  j += 2;
                  if (j ==
                      2 * tournament.finalBoard.numberOfCasesOnFirstColumn) {
                    j = tournament.finalBoard.numberOfCasesOnFirstColumn + 1;
                  }
                }
              }
            }
          }
        }
      }

      if (tournament.pools.length == 0) {
        tournament.finalBoard
            .setNumberOfPlayers(tournament.finalBoard.participants.length);
      }

      if (tournament.poolsClosed) {
        for (int i = tournament.finalBoard.numberOfCasesOnFirstColumn;
            i < 2 * tournament.finalBoard.numberOfCasesOnFirstColumn;
            i++) {
          if (tournament.finalBoard.getParticipantAt(i) == null) {
            tournament.finalBoard.addParticipant(new Participant.initial(
                tournament.finalBoard.getParticipantAt(i - 1).capseurUid,
                '',
                tournament.finalBoard.nextPosition(i)));
          }
        }
      }

      widgetToShow = TournamentView(
        tournament: tournament,
        capseurs: capseurs,
      );
    }

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroundBaseColor,
            shadowColor: Colors.transparent,
            leading: ArrowBackAppBar(),
            bottom: TabBar(
              indicatorColor: kSecondaryColor,
              tabs: [
                Tab(
                  child:
                      Text('Poules', style: TextStyle(color: kSecondaryColor)),
                  icon: Icon(
                    Icons.table_chart,
                    color: kSecondaryColor,
                  ),
                ),
                Tab(
                  child: Text('Tableau final',
                      style: TextStyle(color: kSecondaryColor)),
                  icon: Icon(
                    Icons.list_alt,
                    color: kSecondaryColor,
                  ),
                ),
                Tab(
                  child:
                      Text('Matchs', style: TextStyle(color: kSecondaryColor)),
                  icon: Icon(
                    Icons.list_alt,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
            title: Text(
              tournamentInfo.name,
              style: TextStyle(
                  fontFamily: 'PirataOne',
                  fontSize: 30,
                  color: kSecondaryColor),
            ),
          ),
          body: Stack(
            children: [
              Background(
                image: "assets/images/bottle_-15deg.png",
              ),
              widgetToShow
            ],
          ),
        ));
  }
}
