class Capseur {
  final String _uid;
  String _firstname;
  String _lastname;
  int _rank;
  int _matchsPlayed;
  int _matchsWon;
  int _capsHit;
  int _bottlesEmptied;
  double _points;

  Capseur(this._firstname, this._lastname, this._rank, this._matchsPlayed,
      this._matchsWon, this._capsHit, this._bottlesEmptied, this._uid, this._points);

  String get firstname => _firstname;
  String get lastname => _lastname;
  int get rank => _rank;
  int get matchsPlayed => _matchsPlayed;
  int get matchsWon => _matchsWon;
  int get capsHit => _capsHit;
  int get bottlesEmptied => _bottlesEmptied;
  String get uid => _uid;
  double get points => _points;
}
