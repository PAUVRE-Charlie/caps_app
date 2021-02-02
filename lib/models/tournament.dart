import 'dart:math';

import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournamentInfo.dart';

class Tournament {
  TournamentInfo _tournamentInfo;
  List<Pool> _pools;
  List<MatchOfTournament> _matchs;

  Tournament(this._tournamentInfo, this._pools, this._matchs);

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
  List<MatchOfTournament> get matchs => _matchs;

  int get numberOfPlayersInFinalBoard =>
      this.numberOfPools *
      this.tournamentInfo.numberPlayersGettingOutOfEachPool;

  int get maxMatchsInFinalBoard =>
      (log(this.numberOfPlayersInFinalBoard / ln2)).ceil();

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
}
