class BasicUser {
  final String _uid;
  String _firstname;
  String _lastname;
  int _rank;
  int _matchsPlayed;
  int _matchsWon;
  int _capsHit;
  int _bottlesEmptied;

  BasicUser(this._uid);

  String get uid => _uid;
}
