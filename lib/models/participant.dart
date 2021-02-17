import 'package:caps_app/models/capseur.dart';

class Participant {
  String _capseurUid;
  String _poolUid;
  int _finalBoardPosition;
  int _winsInPool;
  int _defeatsInPool;
  int _capsAverage;

  Participant.initial(
      this._capseurUid, this._poolUid, this._finalBoardPosition) {
    this._winsInPool = 0;
    this._defeatsInPool = 0;
    this._capsAverage = 0;
  }

  String get capseurUid => _capseurUid;
  String get poolUid => _poolUid;
  int get finalBoardPosition => _finalBoardPosition;
  int get winsInPool => _winsInPool;
  int get defeatsInPool => _defeatsInPool;
  int get capsAverage => _capsAverage;

  void _addWin() {
    _winsInPool++;
  }

  void _addDefeat() {
    _defeatsInPool++;
  }

  void addCapsAverage(int average) {
    _capsAverage += average;
    if (average > 0)
      _addWin();
    else
      _addDefeat();
  }

  Capseur getCapseur(List<Capseur> capseurs) {
    return capseurs.firstWhere((capseur) => capseur.uid == this._capseurUid);
  }
}
