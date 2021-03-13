import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchsList.dart';
import 'package:caps_app/components/matchsWaitingList.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/game.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/services/auth.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

import '../data.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.capseur}) : super(key: key);

  final Capseur capseur;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  TextEditingController usernameTextFieldController;
  bool editing;
  Capseur capseur;

  @override
  void initState() {
    capseur = widget.capseur;
    usernameTextFieldController = TextEditingController(text: capseur.username);
    editing = false;
    capseur = widget.capseur;
    super.initState();
  }

  @override
  void dispose() {
    usernameTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);

    if (user == null) return LoadingWidget();

    return StreamProvider<List<MatchWaitingToBeValidated>>.value(
      value: DatabaseService().matchsWaitingToBeValidated,
      child: StreamProvider<List<MatchEnded>>.value(
          value: DatabaseService().matchs,
          child: StreamProvider<List<Capseur>>.value(
              value: DatabaseService().capseurs,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: kBackgroundBaseColor,
                  shadowColor: Colors.transparent,
                  leading: ArrowBackAppBar(),
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      user.uid == capseur.uid && editing
                          ? Expanded(
                              child: TextField(
                                controller: usernameTextFieldController,
                              ),
                            )
                          : Text(
                              usernameTextFieldController.text ??
                                  capseur.username,
                              style: TextStyle(
                                  fontFamily: 'PirataOne',
                                  fontSize: 30,
                                  color: kPrimaryColor),
                            ),
                      user.uid == capseur.uid
                          ? (editing
                              ? Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          editing = !editing;
                                          print(usernameTextFieldController
                                              .value.text.length);
                                          if (usernameTextFieldController
                                                  .value.text.length <=
                                              10) {
                                            DatabaseService().updateCapseurData(
                                                capseur.uid,
                                                usernameTextFieldController
                                                    .value.text,
                                                capseur.matchsPlayed,
                                                capseur.matchsWon,
                                                capseur.capsHit,
                                                capseur.capsThrow,
                                                capseur.bottlesEmptied,
                                                capseur.points,
                                                capseur.victorySerieActual,
                                                capseur.victorySerieMax,
                                                capseur.maxReverse);
                                            capseur.setUsername(
                                                usernameTextFieldController
                                                    .value.text);
                                          } else {
                                            usernameTextFieldController.text =
                                                capseur.username;
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Votre nom ne peut dépasser 10 caractères');
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: kPrimaryColor,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          editing = !editing;
                                          usernameTextFieldController.text =
                                              capseur.username;
                                        });
                                      },
                                    )
                                  ],
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: kSecondaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      editing = !editing;
                                    });
                                  },
                                ))
                          : Container(),
                    ],
                  ),
                  actions: [
                    user.uid == capseur.uid
                        ? IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: kSecondaryColor,
                              size: 30,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false);
                              Future.delayed(Duration(milliseconds: 600),
                                  () => _auth.signOut());
                            },
                          )
                        : SizedBox(
                            width: 55,
                          ),
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
                          if (user.uid != capseur.uid)
                            ChallengeButton(
                              capseurOfProfile: capseur,
                              userUid: user.uid,
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          DataItemProfile(
                              dataName: 'Points',
                              dataValue: capseur.points.round().toString()),
                          RaisedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/rankings');
                              },
                              color: kSecondaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                "Voir les classements",
                                style: TextStyle(color: kWhiteColor),
                              )),
                          DataItemProfile(
                              dataName: 'Matchs gagnés',
                              dataValue: capseur.matchsWon.toString()),
                          DataItemProfile(
                              dataName: 'Matchs joués',
                              dataValue: capseur.matchsPlayed.toString()),
                          DataItemProfile(
                              dataName: 'Caps touchées',
                              dataValue: capseur.capsHit.toString()),
                          DataItemProfile(
                              dataName: 'Ratio',
                              dataValue: (capseur.ratio != null
                                  ? capseur.ratio.toString() + '%'
                                  : '')),
                          DataItemProfile(
                              dataName: 'Kros bues',
                              dataValue:
                                  capseur.bottlesEmptied.toStringAsFixed(1)),
                          DataItemProfile(
                              dataName: 'Serie victoire',
                              dataValue: capseur.victorySerieActual.toString() +
                                  ' (max: ' +
                                  capseur.victorySerieMax.toString() +
                                  ')'),
                          DataItemProfile(
                              dataName: 'Max reverse',
                              dataValue: capseur.maxReverse.toString()),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'DERNIERS MATCHS',
                            style: TextStyle(
                                fontFamily: 'PirataOne', fontSize: 25),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MatchWaitingList(
                            capseur: capseur,
                          ),
                          MatchList(
                            capseur: capseur,
                            maxMatchsDisplayed: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}

class DataItemProfile extends StatefulWidget {
  DataItemProfile({Key key, this.dataName, this.dataValue}) : super(key: key);

  final String dataName;
  final String dataValue;

  @override
  _DataItemProfileState createState() => _DataItemProfileState();
}

class _DataItemProfileState extends State<DataItemProfile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.dataName,
        style: TextStyle(fontFamily: 'PirataOne', fontSize: 25),
      ),
      trailing: Text(widget.dataValue),
    );
  }
}

class ChallengeButton extends StatefulWidget {
  ChallengeButton({Key key, this.capseurOfProfile, this.userUid})
      : super(key: key);

  final Capseur capseurOfProfile;
  final String userUid;

  @override
  _ChallengeButtonState createState() => _ChallengeButtonState();
}

class _ChallengeButtonState extends State<ChallengeButton> {
  @override
  Widget build(BuildContext context) {
    final capseurs = Provider.of<List<Capseur>>(context);

    return RaisedButton(
        onPressed: () async {
          Game.startMatch(context, "Match",
              capseurs.firstWhere((capseur) => capseur.uid == widget.userUid),
              capseur2: widget.capseurOfProfile);
        },
        color: kPrimaryColor,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text(
          "Défier !",
          style: TextStyle(color: kWhiteColor),
        ));
  }
}
