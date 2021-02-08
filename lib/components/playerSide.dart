import 'package:auto_size_text/auto_size_text.dart';
import 'package:caps_app/models/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data.dart';

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
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Center(
                    child: Opacity(
                      opacity: (widget.player.playing) ? 0.2 : 1,
                      child: Image(
                          height: MediaQuery.of(context).size.height * 1 / 5,
                          image: AssetImage(
                              'assets/images/match_bottle_wcaps.png')),
                    ),
                  ),
                  Center(
                      child: Arrow(
                    player: widget.player,
                  ))
                ],
              ),
              Text(
                widget.player.score.toString(),
                style: TextStyle(
                    fontFamily: 'PirataOne',
                    fontSize: 50,
                    color: kPrimaryColor),
              ),
            ],
          ),
        ),
        Column(
          children: [
            widget.player.topPlayerBool
                ? Container(
                    height: MediaQuery.of(context).size.height * 1 / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: widget.bottlesNumber - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Opacity(
                          opacity:
                              (index >= widget.player.bottlesLeftNumber - 1)
                                  ? 0.2
                                  : 1,
                          child: Image(
                              image: AssetImage('assets/images/bottle.png')),
                        );
                      },
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 1 / 10,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
            Container(
              height: MediaQuery.of(context).size.height * 1 / 10,
              width: MediaQuery.of(context).size.width / 3,
              alignment: AlignmentDirectional.center,
              child: AutoSizeText(
                widget.player.capseur.username,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PirataOne',
                    fontSize: 30,
                    color: kPrimaryColor),
              ),
            ),
            !widget.player.topPlayerBool
                ? Container(
                    height: MediaQuery.of(context).size.height * 1 / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: widget.bottlesNumber - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Opacity(
                          opacity:
                              (index >= widget.player.bottlesLeftNumber - 1)
                                  ? 0.2
                                  : 1,
                          child: Image(
                              image: AssetImage('assets/images/bottle.png')),
                        );
                      },
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 1 / 10,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
          ],
        )
      ],
    );
  }
}

class Arrow extends StatelessWidget {
  final Player player;

  Arrow({this.player});

  @override
  Widget build(BuildContext context) {
    if (player.topPlayerBool & player.playing) {
      return Hero(
          tag: 'double_arrow_down',
          child: ImageIcon(
            AssetImage('assets/images/double_arrow_down.png'),
            color: kSecondaryColor,
            size: 100.0,
          ));
    } else if (!player.topPlayerBool & player.playing) {
      return Hero(
          tag: 'double_arrow_up',
          child: ImageIcon(
            AssetImage('assets/images/double_arrow_up.png'),
            color: kSecondaryColor,
            size: 100.0,
          ));
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }
}
