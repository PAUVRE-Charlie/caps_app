import 'package:audioplayers/audio_cache.dart';
import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/playerSide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../models/game.dart';
import '../models/capseur.dart';
import '../models/player.dart';
import 'dart:math';

class MatchPage extends StatefulWidget {
  MatchPage(
      {Key key,
      @required this.title,
      @required this.capseur1,
      @required this.capseur2,
      @required this.bottlesNumber,
      @required this.pointsPerBottle,
      @required this.player1Starting})
      : super(key: key);

  final String title;
  final Capseur capseur1;
  final Capseur capseur2;
  final int bottlesNumber;
  final int pointsPerBottle;
  final bool player1Starting;

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  Game game;
  Game gameLastTurn;
  Capseur capseur1;
  Capseur capseur2;
  bool canRevert;

  final audioplayer = AudioCache();

  Game copyGame(Game gameToCopy) {
    Player clonePlayer1 = Player(gameToCopy.player1.capseur, gameToCopy.player1.score, gameToCopy.player1.bottlesLeftNumber, gameToCopy.player1.currentBottlePointsLeft, true, gameToCopy.player1starting, gameToCopy.player1.capsHitInThisGame, gameToCopy.player1.capsThrowInThisGame);
    Player clonePlayer2 = Player(gameToCopy.player2.capseur, gameToCopy.player2.score, gameToCopy.player2.bottlesLeftNumber, gameToCopy.player2.currentBottlePointsLeft, false, !gameToCopy.player1starting, gameToCopy.player2.capsHitInThisGame, gameToCopy.player2.capsThrowInThisGame);
    return Game(
        clonePlayer1,
        clonePlayer2,
        gameToCopy.reverseCount,
        gameToCopy.pointsRequired,
        gameToCopy.pointsPerBottle,
        gameToCopy.player1starting);
  }

  @override
  void initState() {
    game = Game.initial(widget.capseur1, widget.capseur2, widget.bottlesNumber,
        widget.pointsPerBottle, widget.player1Starting);
    gameLastTurn = copyGame(game);
    canRevert = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    game.setContext(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundBaseColor,
          shadowColor: Colors.transparent,
          leading: ArrowBackAppBar(),
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
          ),
        ),
        body: Stack(
          children: [
            Background(),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerSide(
                      bottlesNumber:
                          game.pointsRequired ~/ game.pointsPerBottle,
                      player: game.player1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: Colors.green,
                                      ),
                                      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                      tooltip: 'touché',
                                      iconSize: 50,
                                      onPressed: () {
                                        setState(() {
                                          int n = Random().nextInt(10);
                                          audioplayer.play('sounds/sonCapsule' +
                                              (n + 1).toString() +
                                              '.wav');
                                          gameLastTurn = copyGame(game);
                                          game.nextTurn(true);
                                          canRevert = true;
                                        });
                                      }),
                                  Text('touché', style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.green),),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 10,
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.thumb_down,
                                        color: kPrimaryColor,
                                      ),
                                      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                      tooltip: 'loupé',
                                      iconSize: 50,
                                      onPressed: () {
                                        setState(() {
                                          gameLastTurn = copyGame(game);
                                          game.nextTurn(false);
                                          canRevert = true;
                                        });
                                      }),
                                  Text('loupé', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                game.reverseCount.toString(),
                                style: TextStyle(
                                    fontSize: 25, color: kPrimaryColor),
                              ),
                              Icon(Icons.bolt, color: kPrimaryColor, size: 40),
                            ],
                          ),
                          Opacity(
                            opacity: canRevert ? 1 : 0.2,
                            child: IconButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 15),
                                icon: Icon(Icons.undo, color: kPrimaryColor),
                                iconSize: 40,
                                onPressed: canRevert
                                    ? () {
                                        setState(() {

                                          print('a');
                                          print(game.player1.score);
                                          print('b');
                                          print(gameLastTurn.player1.score);
                                          print('c');
                                          print(game.player2.score);
                                          print('d');
                                          print(gameLastTurn.player2.score);

                                          game = copyGame(gameLastTurn);
                                          game.switchTurns();
                                          canRevert = false;
                                        });
                                      }
                                    : null),
                          )
                        ],
                      ),
                    ],
                  ),
                  PlayerSide(
                      bottlesNumber:
                          game.pointsRequired ~/ game.pointsPerBottle,
                      player: game.player2,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
