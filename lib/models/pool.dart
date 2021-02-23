import 'package:caps_app/models/participant.dart';

import 'matchEnded.dart';
import 'matchsOfTournament.dart';

class Pool {
  final String _uid;
  String _tournamentUid;
  String _name;
  List<Participant> _participants;
  List<MatchOfTournament> _matchs;

  Pool(this._uid, this._tournamentUid, this._name) {
    _participants = new List();
    _matchs = new List();
  }

  String get uid => _uid;
  String get tournamentUid => _tournamentUid;
  String get name => _name;
  List<Participant> get participants => _participants;
  List<MatchOfTournament> get matchs => _matchs;
  int get numberOfCapseurs => _participants.length;

  bool get closed =>
      _matchs.length == _participants.length * (participants.length - 1) / 2;

  List<Participant> get rankedPartipant {
    List<Participant> _rankedParticipants = _participants;
    _rankedParticipants.sort((x, y) => (x.winsInPool == y.winsInPool)
        ? y.capsAverage.compareTo(x.capsAverage)
        : y.winsInPool.compareTo(x.winsInPool));
    return _rankedParticipants;
  }

  void addParticipant(Participant participant) {
    this._participants.add(participant);
  }

  void removeParticipant(Participant participantToRemove) {
    Participant _participantToRemove;
    for (Participant participant in _participants) {
      if (participant.capseurUid == participantToRemove.capseurUid)
        _participantToRemove = participant;
    }
    _participants.remove(_participantToRemove);
  }

  void addMatch(MatchOfTournament match) {
    this._matchs.add(match);
  }

  void setName(String name) {
    _name = name;
  }

  bool isInThisPool(String capseurUid) {
    for (Participant participant in this.participants) {
      if (participant.capseurUid == capseurUid) return true;
    }
    return false;
  }

  bool canPlay(
      String capseurUid, String opponentUid, List<MatchEnded> allMatchs) {
    if (isInThisPool(capseurUid) &&
        isInThisPool(opponentUid) &&
        opponentUid != capseurUid) {
      for (MatchOfTournament match in this.matchs) {
        if (allMatchs
            .firstWhere((matchEnded) => matchEnded.uid == match.match)
            .isOpposing(capseurUid, opponentUid)) return false;
      }
      return true;
    } else {
      return false;
    }
  }

  void reset() {
    this._matchs = new List();
    this._participants = new List();
  }
}
