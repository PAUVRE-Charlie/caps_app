import 'package:caps_app/models/matchEnded.dart';

class MatchOfTournament {
  MatchEnded _matchEnded;
  String _tournamentUid;
  String _poolUid;
  int _finalBoardPosition;

  MatchOfTournament(this._matchEnded, this._tournamentUid, this._poolUid,
      this._finalBoardPosition);

  MatchEnded get match => _matchEnded;
  String get tournamentUid => _tournamentUid;
  String get poolUid => _poolUid;
  int get finalBoardPosition => _finalBoardPosition;
}
