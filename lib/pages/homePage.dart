import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/components/validateMatch.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/pages/lastMatchs.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:caps_app/pages/randomPickStartPage.dart';
import 'package:caps_app/pages/rankingPage.dart';
import 'package:caps_app/pages/rulesPage.dart';
import 'package:caps_app/pages/tournamentsMenuPage.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../models/game.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);

    return StreamBuilder<Capseur>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        // snapshot = user with all its data
        return snapshot.hasData
            ? StreamProvider<List<MatchWaitingToBeValidated>>.value(
                value: DatabaseService().matchsWaitingToBeValidated,
                child: StreamProvider<List<Capseur>>.value(
                  value: DatabaseService().capseurs,
                  child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: kBackgroundBaseColor,
                        shadowColor: Colors.transparent,
                        leading: IconButton(
                            icon: Icon(
                              Icons.help,
                              color: kSecondaryColor,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (ctxt) => new RulesPage(),
                                  ));
                            }),
                        actions: [
                          IconButton(
                              icon: Icon(
                                Icons.person,
                                color: kSecondaryColor,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (ctxt) => new ProfilePage(
                                        capseur: snapshot.data,
                                      ),
                                    ));
                              })
                        ],
                      ),
                      body: Stack(
                        children: [
                          Background(
                            image: "assets/images/bottle_homePage.png",
                            height: MediaQuery.of(context).size.height * 2 / 3,
                          ),
                          MenuOrValidateMatch(
                            capseur: snapshot.data,
                          ),
                        ],
                      )),
                ),
              )
            : Scaffold(
                body: Stack(
                children: [
                  Background(),
                  Center(
                    child: LoadingWidget(),
                  ),
                ],
              ));
      },
    );
  }
}

class TextButtonMenu extends StatelessWidget {
  const TextButtonMenu({Key key, this.text, this.onPressed}) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w300),
          )),
    );
  }
}

class MenuOrValidateMatch extends StatefulWidget {
  MenuOrValidateMatch({Key key, this.capseur}) : super(key: key);

  final Capseur capseur;

  @override
  _MenuOrValidateMatchState createState() => _MenuOrValidateMatchState();
}

class _MenuOrValidateMatchState extends State<MenuOrValidateMatch> {
  @override
  Widget build(BuildContext context) {
    final matchsWaitingToBeValidated =
        Provider.of<List<MatchWaitingToBeValidated>>(context);
    final capseurs = Provider.of<List<Capseur>>(context);

    if (matchsWaitingToBeValidated == null || capseurs == null)
      return LoadingWidget();

    final matchsNotValidatedWhereUserWasOpponent = matchsWaitingToBeValidated
        .where((match) => match.player1 == widget.capseur.uid);

    MatchWaitingToBeValidated matchWaitingToBeValidated;

    if (matchsNotValidatedWhereUserWasOpponent.isNotEmpty) {
      matchWaitingToBeValidated = matchsNotValidatedWhereUserWasOpponent.first;
    }

    return matchsNotValidatedWhereUserWasOpponent.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Caps",
                  style: TextStyle(
                      fontSize: 100,
                      fontFamily: 'PirataOne',
                      color: kSecondaryColor),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  decoration: BoxDecoration(
                      color: kWhiteHighOpacity,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      TextButtonMenu(
                          text: "Jouer",
                          onPressed: () {
                            Game.startMatch(
                                context, "Match", widget.capseur);
                          }),
                      // TextButtonMenu(
                      //     text: "Tournois",
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           new MaterialPageRoute(
                      //             builder: (ctxt) => new TournamentsMenuPage(),
                      //           ));
                      //     }),
                      TextButtonMenu(
                        text: "Classements",
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (ctxt) => new RankingPage(),
                              ));
                        },
                      ),
                      TextButtonMenu(
                        text: "Derniers matchs",
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (ctxt) => new LastMatchs(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : ValidateMatch(capseurs, matchWaitingToBeValidated);
  }
}
