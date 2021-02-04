import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/components/matchsList.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/pages/lastMatchs.dart';
import 'package:caps_app/pages/rankingPage.dart';
import 'package:caps_app/services/auth.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.capseur}) : super(key: key);

  final Capseur capseur;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);

    if (user == null) return LoadingWidget();

    return StreamProvider<List<MatchEnded>>.value(
        value: DatabaseService().matchs,
        child: StreamProvider<List<Capseur>>.value(
            value: DatabaseService().capseurs,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kBackgroundBaseColor,
                shadowColor: Colors.transparent,
                leading: ArrowBackAppBar(),
                centerTitle: true,
                title: Text(
                  widget.capseur.firstname + ' ' + widget.capseur.lastname,
                  style: TextStyle(
                      fontFamily: 'PirataOne',
                      fontSize: 30,
                      color: kPrimaryColor),
                ),
                actions: [
                  user.uid == widget.capseur.uid ?
                  IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: kSecondaryColor,
                        size: 30,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _auth.signOut();
                        },
                  )

                :Container()],
              ),
              body: Stack(
                children: [
                  Background(
                    image: "assets/images/bottle_32deg.png",
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        DataItemProfile(
                            dataName: 'Points',
                            dataValue:
                                widget.capseur.points.round().toString()),
                        RaisedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new RankingPage(),
                                ),
                              );
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
                            dataValue: widget.capseur.matchsWon.toString()),
                        DataItemProfile(
                            dataName: 'Matchs joués',
                            dataValue: widget.capseur.matchsPlayed.toString()),
                        DataItemProfile(
                            dataName: 'Caps touchées',
                            dataValue: widget.capseur.capsHit.toString()),
                        DataItemProfile(
                            dataName: 'Ratio',
                            dataValue: (widget.capseur.capsThrow != 0) ? (widget.capseur.capsHit/widget.capseur.capsThrow*100).round().toString()+'%' : ''),
                        DataItemProfile(
                            dataName: 'Kros bues',
                            dataValue:
                                widget.capseur.bottlesEmptied.toString()),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'MES DERNIERS MATCHS',
                          style:
                              TextStyle(fontFamily: 'PirataOne', fontSize: 25),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MatchList(
                          capseur: widget.capseur,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
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
