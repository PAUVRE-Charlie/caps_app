import 'dart:ui';

import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import 'rulesPage.dart';

class RulesPageEnglish extends StatelessWidget {
  const RulesPageEnglish({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        leading: ArrowBackAppBar(),
        title: Text(
          'Rules',
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
        ),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(15.0),
            child: Image(image: AssetImage("assets/images/france.png")),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/rules');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Background(
            image: "assets/images/bottle_32deg.png",
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                TextRules(
                    "Both player (aka capseur) situated opposite each other, sit down on the floor. The distance between players is determined by the length of their stretched legs.",
                    index: 1),
                TextRules(
                    "Each player open his beer bottle, let down the bottle between his legs and place the cap, on the back, on the top of the bottle.",
                    index: 2),
                Image.asset(
                  "assets/images/match_bottle_wcaps.png",
                  height: MediaQuery.of(context).size.height / 7,
                ),
                TextRules("in order to play, you need 3 caps at least.",
                    textToEmphasize: "Tips: "),
                TextRules(
                    "To determine who begins, a random draw \"pile ou caps\" is done",
                    index: 3),
                TextRules(
                    "The designated player throws a cap to try to hit the opponent's cap.\nIf the player miss the cap, nothing appends and it's the other player turn",
                    index: 4),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/lancerCaps.gif",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                TextRules(
                    "When a player 1 hit the player 2's cap and make it droped out of the bottle, the player 2 have to riposte. Thus, player 2 throw a cap and 2 options are offered :\nIf he/she doesn't hit the player 1's cap, then player 2 drinks 1 part of his beer (usually one quarter of the bottle but you can change this value as you want) and player 1 marks 1 point.\nElse, if he/she hits the player 2's cap, then there is now 2 points involved in the riposte.\nThen, repeat the patern as is necessary : player 1 throw a cap and 2 options are offered. If he/she doesn't hit the player 2's cap, then player 1 drinks 2 part of his beer (usually two quarter) and player 2 marks 2 points.\nElse, if he/she hits the player 1's cap, then there is now 3 points involved in the riposte...etc...",
                    index: 5),
                TextRules(
                  "You are able to choose the number of points per bottle and number of bottles in a match, usually you'll play in 12 or 16 points with 4 points per bottle (so 3 or 4 beer). After it's up to you to play with other configurations.",
                  textToEmphasize: "BE CAREFUL: ",
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/drinkBeer.gif",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                TextRules(
                    "End of the game : when a player reaches or exceeds the number of point required (without counting the riposte involved), the other player loose and have drink all his beers.",
                    index: 6),
                TextRules(
                  "some contentious situations could appeared but they are ellucidated in this section.The goal of the game is to hit the opponent's cap and make it drops on othe floor, there is no other way to mark a point. For instance, if you violently hit the bootle which make the cap drop on the floor, it doesn't count (it's call the lumberman shot). As well, if you hit the caps after a bounce on the oponnent's player for instance, it doesn't count. Finally if you just brush the cap without make it quit the top of the bootle, it doesn't count.",
                  textToEmphasize: "BE CAREFUL: ",
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Ranking, how does it works ?",
                  style: TextStyle(
                      fontFamily: "PirataOne",
                      fontSize: 25,
                      color: kPrimaryColor),
                ),
                TextRules(
                  "\nEach new player begins with 100 points. If you win a match you'll earn points, if you lose you'll lose points, it's easy, isn't it ?\nObviously, if you win against a player with more points than you, you'll earn more points compare to a victory against a player with less points than you. Conversly, if you lose against a player with less points than you, you'll lose more points compare to a defeat against a player which have less points than you.\nIt's importante to notice that in order to reward players who play a lot, at the outcome of a match the looser loses 80% of the points earned by the winner.\nExample: let's take 2 players with the same number of points. They do a match in 16 points. The winner will earn 5 points while the looser will lose 4 points. Thus, the total of points in the whole app increase with each match. Eventually, if the match is played in 4 points, there will have less points attributed to the winner (0.25 coefficient) compare to a match played in 32 points (2 coefficient). These coefficients simulate the reliability of the match score.",
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Have a good time !",
                  style: TextStyle(
                      fontFamily: "PirataOne",
                      fontSize: 25,
                      color: kPrimaryColor),
                ),
                TextRules(
                    "\n(We are not responsible of the issues involved by your alcohol consumption )"),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Autors of the app : Charlie PAUVRE & Pierre SCHMUTZ",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
