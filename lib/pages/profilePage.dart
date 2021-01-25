import 'package:caps_app/components/loading.dart';
import 'package:caps_app/components/matchResults.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/services/auth.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kSecondaryColor),
          onPressed: () {
            Navigator.of(context)
                .pop(); // delete this line when finish editing it and decomment the one in the onConfirm of startMatchMethod
          },
        ),
        centerTitle: true,
        title: Text(
          widget.capseur.firstname + ' ' + widget.capseur.lastname,
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kPrimaryColor),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBackgroundBaseColor, kBackgroundSecondColor]),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                DataItemProfile(
                    dataName: 'Classement',
                    dataValue: widget.capseur.rank.toString()),
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
                    dataName: 'Kros bues',
                    dataValue: widget.capseur.bottlesEmptied.toString()),
                SizedBox(
                  height: 15,
                ),
                user.uid == widget.capseur.uid
                    ? RaisedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          _auth.signOut();
                        },
                        color: kPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Deconnexion",
                          style: TextStyle(color: kWhiteColor),
                        ))
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'DERNIERS MATCHS',
                  style: TextStyle(fontFamily: 'PirataOne', fontSize: 25),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                      MatchResults(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
