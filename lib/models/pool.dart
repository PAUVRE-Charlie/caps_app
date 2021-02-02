import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/participant.dart';

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
      if (participant.capseur.uid == participantToRemove.capseur.uid)
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
}
