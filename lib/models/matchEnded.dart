import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEnded {
  String _uid;
  String _capseur1;
  String _capseur2;
  Timestamp _date;
  int _scorePlayer1;
  int _scorePlayer2;

  MatchEnded(this._uid, this._capseur1, this._capseur2, this._date,
      this._scorePlayer1, this._scorePlayer2);

  String get uid => _uid;
  String get player1 => _capseur1;
  String get player2 => _capseur2;
  Timestamp get date => _date;
  int get scorePlayer1 => _scorePlayer1;
  int get scorePlayer2 => _scorePlayer2;
  bool get player1Won => _scorePlayer1 > _scorePlayer2;

  String get winnerUid => this.player1Won ? _capseur1 : _capseur2;

  bool isOpposing(String capseurUid1, String capseurUid2) {
    return ((capseurUid1 == this._capseur1 && capseurUid2 == this._capseur2) ||
        (capseurUid2 == this._capseur1 && capseurUid1 == this._capseur2));
  }
}
