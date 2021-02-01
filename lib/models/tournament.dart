import 'dart:math';

import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournamentInfo.dart';

class Tournament {
  TournamentInfo _tournamentInfo;
  List<Pool> _pools;
  List<MatchEnded> _matchs;

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
  List<MatchEnded> get matchs => _matchs;

  int get maxMatchsInFinalBoard => (log(this.numberOfPools *
              this.tournamentInfo.numberPlayersGettingOutOfEachPool) /
          ln2)
      .ceil();

  int get maxNumberOfPlayersPerPool =>
      (this.numberOfCapseurs / this.numberOfPools).ceil();
}
