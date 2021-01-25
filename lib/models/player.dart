import 'capseur.dart';

class Player {
  Capseur _capseur;
  int _score;
  int _bottlesLeftNumber;
  int _currentBottlePointsLeft;
  bool _topPlayerBool;
  bool _playing;
  int _capsHitInThisGame;

  Player.initial(this._capseur, this._topPlayerBool, int initialBottlesNumber,
      int gamePointsPerBottle, bool starting) {
    _score = 0;
    _bottlesLeftNumber = initialBottlesNumber;
    _currentBottlePointsLeft = gamePointsPerBottle;
    _playing = starting;
    _capsHitInThisGame = 0;
  }

  Player(
      this._capseur,
      this._score,
      this._bottlesLeftNumber,
      this._currentBottlePointsLeft,
      this._topPlayerBool,
      this._playing,
      this._capsHitInThisGame);

  Capseur get capseur => _capseur;
  int get score => _score;
  int get bottlesLeftNumber => _bottlesLeftNumber;
  int get currentBottlePointsLeft => _currentBottlePointsLeft;
  bool get topPlayerBool => _topPlayerBool;
  bool get playing => _playing;
  int get capsHitInThisGame => _capsHitInThisGame;

  setScore(int score) {
    _score = score;
  }

  addCapsHit() {
    _capsHitInThisGame++;
  }

  setPlaying(bool playing) {
    _playing = playing;
  }

  drink(int pointsToDrink, int pointsPerBottle) {
    bool _drinking = true;
    int _pointsToDrinkLeft = pointsToDrink;
    while (_drinking) {
      if (_currentBottlePointsLeft <= _pointsToDrinkLeft) {
        _bottlesLeftNumber--;
        _pointsToDrinkLeft -= _currentBottlePointsLeft;
        _currentBottlePointsLeft = pointsPerBottle;
      } else {
        _currentBottlePointsLeft -= _pointsToDrinkLeft;
        _drinking = false;
      }
    }
  }
}
