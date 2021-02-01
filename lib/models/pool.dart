import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';

class Pool {
  final String _uid;
  List<Capseur> _capseurs;
  List<MatchEnded> _matchs;

  Pool(this._uid) {
    _capseurs = new List();
    _matchs = new List();
  }

  String get uid => _uid;
  List<Capseur> get capseurs => _capseurs;
  List<MatchEnded> get matchs => _matchs;
  int get numberOfCapseurs => _capseurs.length;

  void addCapseur(Capseur capseur) {
    this._capseurs.add(capseur);
  }

  void addMatch(MatchEnded match) {
    this._matchs.add(match);
  }
}
