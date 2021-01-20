import 'package:caps_app/pages/matchPage.dart';
import 'package:caps_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../game.dart';
import '../capseur.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Capseur>(context);

    return Scaffold(
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
                onPressed: () async {
                  await _auth.signOut();
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
                      colors: [kBackgroundBaseColor, kBackgroundSecondColor])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  height: MediaQuery.of(context).size.height * 3 / 5,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/bottle_homePage.png"),
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
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    decoration: BoxDecoration(
                        color: kWhiteHighOpacity,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        TextButtonMenu(
                            text: "Match amical",
                            onPressed: () {
                              Game.startMatch(context, "Match Amical", user);
                            }),
                        TextButtonMenu(
                            text: "Match officiel",
                            onPressed: () {
                              Game.startMatch(context, "Match Officiel", user);
                            }),
                        TextButtonMenu(text: "Classements"),
                        TextButtonMenu(text: "Derniers matchs"),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
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
