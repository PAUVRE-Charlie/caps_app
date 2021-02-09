class Capseur {
  final String _uid;
  String _username;
  int _matchsPlayed;
  int _matchsWon;
  int _capsHit;
  int _capsThrow;
  int _bottlesEmptied;
  double _points;

  Capseur(this._username, this._matchsPlayed, this._matchsWon, this._capsHit,
      this._capsThrow, this._bottlesEmptied, this._uid, this._points);

  String get username => _username;
  int get matchsPlayed => _matchsPlayed;
  int get matchsWon => _matchsWon;
  int get capsHit => _capsHit;
  int get capsThrow => _capsThrow;
  int get ratio => (this.capsThrow != 0)
      ? (this.capsHit / this.capsThrow * 100).round()
      : null;

  int get bottlesEmptied => _bottlesEmptied;
  String get uid => _uid;
  double get points => _points;

  void setUsername(String newUsername) {
    _username = newUsername;
  }
}
