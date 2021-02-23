class Capseur {
  final String _uid;
  String _username;
  int _matchsPlayed;
  int _matchsWon;
  int _capsHit;
  int _capsThrow;
  int _bottlesEmptied;
  double _points;
  int _victorySerieActual;
  int _victorySerieMax;
  int _maxReverse;

  Capseur(this._username, this._matchsPlayed, this._matchsWon, this._capsHit,
      this._capsThrow, this._bottlesEmptied, this._uid, this._points, this._victorySerieActual, this._victorySerieMax, this._maxReverse);

  String get username => _username;
  int get matchsPlayed => _matchsPlayed;
  int get matchsWon => _matchsWon;
  int get capsHit => _capsHit;
  int get capsThrow => _capsThrow;
  int get ratio => (this.capsThrow != 0)
      ? (this.capsHit / this.capsThrow * 100).round()
      : 0;

  int get bottlesEmptied => _bottlesEmptied;
  String get uid => _uid;
  double get points => _points;
  int get victorySerieMax => _victorySerieMax;
  int get victorySerieActual => _victorySerieActual;
  int get maxReverse => _maxReverse;

  void setUsername(String newUsername) {
    _username = newUsername;
  }
}
