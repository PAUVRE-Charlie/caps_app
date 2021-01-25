import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../models/game.dart';
import '../models/capseur.dart';
import '../models/player.dart';
import 'dart:math';

class MatchPage extends StatefulWidget {
  MatchPage(
      {Key key,
      this.title,
      this.capseur1,
      this.capseur2,
      this.bottlesNumber,
      this.pointsPerBottle})
      : super(key: key);

  final String title;
  final Capseur capseur1;
  final Capseur capseur2;
  final int bottlesNumber;
  final int pointsPerBottle;

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
        Player(
            capseur1,
            gameToCopy.player1.score,
            gameToCopy.player1.bottlesLeftNumber,
            gameToCopy.player1.currentBottlePointsLeft,
            gameToCopy.player1.topPlayerBool,
            gameToCopy.player1.playing),
        Player(
            capseur2,
            gameToCopy.player2.score,
            gameToCopy.player2.bottlesLeftNumber,
            gameToCopy.player2.currentBottlePointsLeft,
            gameToCopy.player2.topPlayerBool,
            gameToCopy.player2.playing),
        gameToCopy.reverseCount,
        gameToCopy.pointsRequired,
        gameToCopy.pointsPerBottle);
  }

  @override
  void initState() {
    game = Game.initial(widget.capseur1, widget.capseur2, widget.bottlesNumber,
        widget.pointsPerBottle);
    gameLastTurn = Game.initial(widget.capseur1, widget.capseur2,
        widget.bottlesNumber, widget.pointsPerBottle);
    canRevert = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundBaseColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: kSecondaryColor),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // delete this line when finish editing it and decomment the one in the onConfirm of startMatchMethod
            },
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kBackgroundBaseColor, kBackgroundSecondColor])),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerSide(
                      bottlesNumber:
                          game.pointsRequired ~/ game.pointsPerBottle,
                      player: game.player1),
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
                                      audioplayer.play('sounds/sonCapsule'+(n+1).toString()+'.wav');
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
                                icon: Icon(Icons.undo,
                                    color: kPrimaryColor),
                                iconSize: 40,
                                onPressed: canRevert
                                    ? () {
                                        setState(() {
                                          game = copyGame(gameLastTurn);
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
                      player: game.player2),
                ],
              ),
            )
          ],
        ));
  }
}

class PlayerSide extends StatefulWidget {
  PlayerSide({Key key, this.player, this.bottlesNumber}) : super(key: key);

  final Player player;
  final int bottlesNumber;

  @override
  _PlayerSideState createState() => _PlayerSideState();
}

class _PlayerSideState extends State<PlayerSide> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: widget.player.topPlayerBool
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end,
      children: [
        Expanded(
            child: Column(
          verticalDirection: widget.player.topPlayerBool
              ? VerticalDirection.down
              : VerticalDirection.up,
          children: [
            Opacity(
              opacity: (widget.player.playing) ? 0.2 : 1,
              child: Image(
                  height: MediaQuery.of(context).size.height * 1 / 5,
                  image: AssetImage('assets/images/match_bottle_wcaps.png')),
            ),
            Text(
              widget.player.score.toString(),
              style: TextStyle(
                  fontFamily: 'PirataOne', fontSize: 50, color: kPrimaryColor),
            )
          ],
        )),
        Container(
            height: MediaQuery.of(context).size.height * 1 / 10,
            width: MediaQuery.of(context).size.width / 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: widget.bottlesNumber - 1,
              itemBuilder: (BuildContext context, int index) {
                return Opacity(
                  opacity:
                      (index >= widget.player.bottlesLeftNumber - 1) ? 0.2 : 1,
                  child: Image(image: AssetImage('assets/images/bottle.png')),
                );
              },
            ))
      ],
    );
  }
}
