import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/pages/lastMatchs.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:caps_app/pages/rankingPage.dart';
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
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: kBackgroundBaseColor,
                  shadowColor: Colors.transparent,
                  leading: IconButton(
                      icon: Icon(
                        Icons.help,
                        color: kSecondaryColor,
                        size: 30,
                      ),
                      onPressed: null),
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
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            kBackgroundBaseColor,
                            kBackgroundSecondColor
                          ])),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: 0.7,
                        child: Image(
                          height: MediaQuery.of(context).size.height * 3 / 5,
                          fit: BoxFit.fill,
                          image:
                              AssetImage("assets/images/bottle_homePage.png"),
                        ),
                      ),
                    ),
                    Center(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 30),
                            decoration: BoxDecoration(
                                color: kWhiteHighOpacity,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                TextButtonMenu(
                                    text: "Match amical",
                                    onPressed: () {
                                      Game.startMatch(context, "Match Amical",
                                          snapshot.data);
                                    }),
                                TextButtonMenu(
                                    text: "Match officiel",
                                    onPressed: () {
                                      Game.startMatch(context, "Match Officiel",
                                          snapshot.data);
                                    }),
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
                  ],
                ))
            : Container();
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
