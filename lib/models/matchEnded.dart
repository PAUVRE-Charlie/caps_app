import 'package:caps_app/models/capseur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEnded {
  String _uid;
  String _capseur1;
  String _capseur2;
  Timestamp _date;
  int _scorePlayer1;
  int _scorePlayer2;
  bool _player1Won;
  String _uidTournament;
  String _poolUid;

  MatchEnded.official(
      this._uid,
      this._capseur1,
      this._capseur2,
      this._date,
      this._scorePlayer1,
      this._scorePlayer2,
      this._uidTournament,
      this._poolUid) {
    this._player1Won = this._scorePlayer1 > this._scorePlayer2;
  }

  MatchEnded.casual(this._uid, this._capseur1, this._capseur2, this._date,
      this._scorePlayer1, this._scorePlayer2) {
    this._player1Won = this._scorePlayer1 > this._scorePlayer2;
  }

  String get uid => _uid;
  String get player1 => _capseur1;
  String get player2 => _capseur2;
  Timestamp get date => _date;
  int get scorePlayer1 => _scorePlayer1;
  int get scorePlayer2 => _scorePlayer2;
  bool get player1Won => _player1Won;
  String get uidTournament => _uidTournament ?? '';
  String get poolUid => _poolUid ?? '';
}
