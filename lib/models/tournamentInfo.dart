class TournamentInfo {
  final String _uid;
  String _name;
  int _numberMaxPlayers;
  int _numberPlayersGettingOutOfEachPool;

  TournamentInfo(this._uid, this._name, this._numberMaxPlayers,
      this._numberPlayersGettingOutOfEachPool);

  String get uid => _uid;
  String get name => _name;
  int get numberMaxPlayers => _numberMaxPlayers;
  int get numberPlayersGettingOutOfEachPool =>
      _numberPlayersGettingOutOfEachPool;
}
