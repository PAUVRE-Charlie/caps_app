import 'dart:ui';

import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

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
            image: Platform.isIOS ? "assets/images/ios_bottle_32deg.png" : "assets/images/bottle_32deg.png",
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                TextRules(
                    "Both players (aka capseurs) facing each other, sit down on the floor. The distance between players is determined by the length of their stretched legs.",
                    index: 1),
                TextRules(
                    Platform.isIOS ? "Each player place a bottle between his legs and place the cap upside down on the top of the bottle."
                        : "Each player opens his beer bottle, puts down the bottle between his legs and place the cap upside down on the top of the bottle.",
                    index: 2),
                Image.asset(
                  Platform.isIOS ? "assets/images/ios_match_bottle_wcaps.png"
                  : "assets/images/match_bottle_wcaps.png",
                  height: MediaQuery.of(context).size.height / 7,
                ),
                TextRules("in order to play, you need 3 caps at least.",
                    textToEmphasize: "Tips: "),
                TextRules(
                    "To determine who begins to play, a random draw \"pile ou caps\" is done",
                    index: 3),
                TextRules(
                    "The designated player throws a cap to try to hit the opponent's cap.\nIf the player miss the cap, nothing happens and it's the other player's turn",
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
                  Platform.isIOS ? "When a player 1 hits the player 2's cap and drops the caps from the bottle, the player 2 has to counter. Thus, player 2 throws a cap and there are two possibilities :\nIf he/she doesn't hit the player 1's cap, then player 2 drinks 1 part of his bottle (usually one quarter of the bottle but you can change this value as you want) and player 1 scores 1 point.\nElse, if he/she hits the player 2's cap, then there is now 2 points at stake.\nThen, repeat the pattern as many times as needed : player 1 throws a cap and there are again 2 possibilities. If he/she doesn't hit the player 2's cap, then player 1 drinks 2 parts of his bottle (usually two quarter) and player 2 scores 2 points.\nElse, if he/she hits the player 1's cap, then there are now 3 points at stake...etc..."
                      : "When a player 1 hits the player 2's cap and drops the caps from the bottle, the player 2 has to counter. Thus, player 2 throws a cap and there are two possibilities :\nIf he/she doesn't hit the player 1's cap, then player 2 drinks 1 part of his beer (usually one quarter of the bottle but you can change this value as you want) and player 1 scores 1 point.\nElse, if he/she hits the player 2's cap, then there is now 2 points at stake.\nThen, repeat the pattern as many times as needed : player 1 throws a cap and there are again 2 possibilities. If he/she doesn't hit the player 2's cap, then player 1 drinks 2 parts of his beer (usually two quarter) and player 2 scores 2 points.\nElse, if he/she hits the player 1's cap, then there are now 3 points at stake...etc...",
                    index: 5),
                TextRules(
                  Platform.isIOS ? "You are able to choose the number of points per bottle and number of bottles in a match, usually you'll play in 12 or 16 points with 4 points per bottle (so 3 or 4 bottles). After it's up to you to play with other configurations."
                  : "You are able to choose the number of points per bottle and number of bottles in a match, usually you'll play in 12 or 16 points with 4 points per bottle (so 3 or 4 beers). After it's up to you to play with other configurations.",
                  textToEmphasize: "BE CAREFUL: ",
                ),
                Platform.isIOS ? Container()
                    : Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Image.asset(
                          "assets/images/drinkBeer.gif",
                          width: MediaQuery.of(context).size.width * 5 / 6,
                        ),
                      ),
                    ),
                TextRules(
                    "End of the game : when a player reaches or exceeds the number of points required (without counting the reverse count currently at stake), the other player loses and has to finish to drink all his bottles.",
                    index: 6),
                TextRules(
                  "some contentious situations could appear but they are ellucidated in this section.The goal of the game is to hit the opponent's cap and make it drop on the floor, there is no other way to mark a point. For instance, if you violently hit the bottle which make the cap drop on the floor, it doesn't count (it's call the lumberman shot). As well, if you hit the caps after a bounce on the oponnent's player for instance, it doesn't count. Finally if you just brush the cap without make it drop from the top of the bottle, it doesn't count.",
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
                  "\nEach new player begins with 100 points. If you win a match you'll earn points, if you lose you'll lose points, it's easy, isn't it ?\nObviously, if you win against a player with more points than you, you'll earn more points compared to a victory against a player with less points than you. Conversely, if you lose against a player with less points than you, you'll lose more points compared to a defeat against a player which have more points than you.\nIt's important to notice that in order to reward players who play a lot, at the outcome of a match the loser loses 80% of the points earned by the winner.\nExample: let's take 2 players with the same number of points. They make a match in 16 points. The winner will earn 5 points while the loser will lose 4 points. Thus, the total of points in the whole app increases with each match. Eventually, if the match is played in 4 points, there will have less points attributed to the winner (0.25 coefficient) compare to a match played in 32 points (2 coefficient). These coefficients simulates the reliability of the match score. Eventually, a drinking coefficient is added. It add value to matches with a low number of points per bottle, and it remove value to matches with a high number of points per bottles, there is a 1 coefficient for a match with 4 points per bottle.",
                ),
                TextRules(
                  "\nPoints gained = gain regarding the points gap * reliability coefficient * drinking coefficient",
                  textToEmphasize : "Victory : ",
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextRules(
                    "\nPoints lose = Victory points gained * 0.8",
                    textToEmphasize : "Defeat : ",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/courbesGains.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/coeffFiabilite.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/coeffBuvabilite.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
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
                Platform.isIOS ? Container()
                : TextRules(
                    "\n(We are not responsible for the issues related to your alcohol consumption )"),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Autors of the app : Charlie PAUVRÉ & Pierre SCHMUTZ",
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
