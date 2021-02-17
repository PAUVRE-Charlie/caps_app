import 'package:caps_app/models/finalBoard.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournamentInfo.dart';

class Tournament {
  TournamentInfo _tournamentInfo;
  List<Pool> _pools;
  List<MatchOfTournament> _matchsOfTournaments;
  List<MatchEnded> _matchs;
  FinalBoard _finalBoard;

  Tournament(this._tournamentInfo, this._pools, this._matchsOfTournaments,
      this._matchs) {
    _finalBoard = FinalBoard();
  }

  int get numberOfPools => _pools.length;

  int get numberOfCapseurs {
    int count = 0;
    for (Pool pool in _pools) {
      count += pool.numberOfCapseurs;
    }
    return count;
  }

  TournamentInfo get tournamentInfo => _tournamentInfo;
  List<Pool> get pools => _pools;
  List<MatchOfTournament> get matchsOfTournaments => _matchsOfTournaments;
  List<MatchEnded> get matchs => _matchs;
  FinalBoard get finalBoard => _finalBoard;

  int get maxNumberOfPlayersPerPool =>
      (this.numberOfCapseurs / this.numberOfPools).ceil();

  int get numberOfPlayers {
    int count = 0;
    for (Pool pool in _pools) {
      count += pool.participants.length;
    }
    return count;
  }

  bool get poolsClosed {
    for (Pool pool in _pools) {
      if (!pool.closed) return false;
    }
    return true;
  }

  bool get tournamentClosed {
    return this.finalBoard.getParticipantAt(1) != null;
  }
}
