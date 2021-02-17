import 'dart:math';

import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournamentInfo.dart';

class FinalBoard {
  List<Participant> _participants;
  List<MatchOfTournament> _matchs;
  int _numberOfPlayers;

  FinalBoard() {
    _participants = new List();
    _matchs = new List();
    _numberOfPlayers = 0;
  }

  List<Participant> get participants => _participants;
  List<MatchOfTournament> get matchs => _matchs;
  int get numberOfPlayers => _numberOfPlayers;

  int get maxMatchs => (log(this.numberOfPlayers) / ln2).ceil();

  int get numberOfCasesOnFirstColumn => pow(2, this.maxMatchs);

  void setNumberOfPlayers(int number) {
    this._numberOfPlayers = number;
  }

  Participant getParticipantAt(int position) {
    return this._participants.firstWhere(
        (participant) => participant.finalBoardPosition == position,
        orElse: () => null);
  }

  void addParticipant(Participant participant) {
    this._participants.add(participant);
  }

  int nextPosition(int position) {
    return position ~/ 2;
  }

  List<int> previousPositions(int position) {
    return [2 * position, 2 * position + 1];
  }

  int lastPosition(String capseurUid) {
    List<int> positionsOfThisCapseur = this
        .participants
        .map((participant) => participant.capseurUid == capseurUid
            ? participant.finalBoardPosition
            : 1000000)
        .toList();
    positionsOfThisCapseur.sort();
    return positionsOfThisCapseur.first;
  }

  bool isInFinalBoard(String capseurUid) {
    for (Participant participant in participants) {
      if (participant.capseurUid == capseurUid) return true;
    }
    return false;
  }

  bool hasAMatchToPlay(String capseurUid) {
    if (!isInFinalBoard(capseurUid)) return false;
    for (MatchOfTournament match in this.matchs) {
      if (match.finalBoardPosition ==
          this.nextPosition(this.lastPosition(capseurUid))) {
        return false;
      }
    }
    return true;
  }

  bool playInThisMatch(String capseurUid, int matchPos) {
    return (hasAMatchToPlay(capseurUid) &&
        this.nextPosition(this.lastPosition(capseurUid)) == matchPos);
  }

  List<Participant> participantsInMatch(int matchPos) {
    return this
        .previousPositions(matchPos)
        .map((pos) => getParticipantAt(pos))
        .toList();
  }
}
