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
      this._player2CapsHitInThisGame);

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
}
