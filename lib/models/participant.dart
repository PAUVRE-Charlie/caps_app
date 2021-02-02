import 'package:caps_app/models/capseur.dart';

class Participant {
  Capseur _capseur;
  int _winsInPool;
  int _defeatsInPool;
  int _capsAverage;

  Participant(this._capseur, this._winsInPool, this._defeatsInPool);

  Participant.initial(this._capseur) {
    this._winsInPool = 0;
    this._defeatsInPool = 0;
    this._capsAverage = 0;
  }

  Capseur get capseur => _capseur;
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
}
