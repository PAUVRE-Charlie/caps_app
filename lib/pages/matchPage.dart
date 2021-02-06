import 'package:audioplayers/audio_cache.dart';
import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/player_side.dart';
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
    return Game(
        gameToCopy.player1,
        gameToCopy.player2,
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
                          Text(
                            "${game.player1.playing ? game.player1.capseur.firstname : game.player2.capseur.firstname} est en train de jouer",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: Colors.green,
                                  ),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 10,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: kPrimaryColor,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    setState(() {
                                      gameLastTurn = copyGame(game);
                                      game.nextTurn(false);
                                      canRevert = true;
                                    });
                                  }),
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
