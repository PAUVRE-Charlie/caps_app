import 'package:cloud_firestore/cloud_firestore.dart';

class MatchWaitingToBeValidated {
  // SAME AS MatchEnded
  String _uid;
  String _capseur1;
  String _capseur2;
  Timestamp _date;
  int _scorePlayer1;
  int _scorePlayer2;

  // data used to update users' stats
  int _pointsRequired;
  int _pointsPerBottle;
  int _player1CapsHitInThisGame;
  int _player2CapsHitInThisGame;
  int _player1CapsThrowInThisGame;
  int _player2CapsThrowInThisGame;
  int _maxGameReverse;

  String _tournamentUid;
  String _poolUid;
  int _finalBoardPosition;

  MatchWaitingToBeValidated(
      this._uid,
      this._capseur1,
      this._capseur2,
      this._date,
      this._scorePlayer1,
      this._scorePlayer2,
      this._pointsRequired,
      this._pointsPerBottle,
      this._player1CapsHitInThisGame,
      this._player1CapsThrowInThisGame,
      this._player2CapsHitInThisGame,
      this._player2CapsThrowInThisGame,
      this._maxGameReverse,
      this._tournamentUid,
      this._poolUid,
      this._finalBoardPosition);

  String get uid => _uid;
  String get player1 => _capseur1;
  String get player2 => _capseur2;
  Timestamp get date => _date;
  int get scorePlayer1 => _scorePlayer1;
  int get scorePlayer2 => _scorePlayer2;
  bool get player1Won => _scorePlayer1 > _scorePlayer2;
  int get pointsRequired => _pointsRequired;
  int get pointsPerBottle => _pointsPerBottle;
  int get player1CapsHitInThisGame => _player1CapsHitInThisGame;
  int get player2CapsHitInThisGame => _player2CapsHitInThisGame;
  int get player1CapsThrowInThisGame => _player1CapsThrowInThisGame;
  int get player2CapsThrowInThisGame => _player2CapsThrowInThisGame;
  int get maxGameReverse => _maxGameReverse;
  String get tournamentUid => _tournamentUid == '' ? null : _tournamentUid;
  String get poolUid => _poolUid == '' ? null : _poolUid;
  int get finalBoardPosition =>
      _finalBoardPosition == 0 ? null : _finalBoardPosition;

  bool isOpposing(String capseurUid1, String capseurUid2) {
    return ((capseurUid1 == this._capseur1 && capseurUid2 == this._capseur2) ||
        (capseurUid2 == this._capseur1 && capseurUid1 == this._capseur2));
  }
}
