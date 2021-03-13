import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/pages/profilePage.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../data.dart';

enum Filter { POINTS, MATCHSWON, MATCHSPLAYED, CAPSHIT, RATIO, KROEMPTIED, VICTORYSERIEMAX, MAXREVERSE}

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String filterToString(Filter filter) {
    switch (filter) {
      case Filter.POINTS:
        return 'Points';
        break;
      case Filter.MATCHSWON:
        return 'Matchs gagnés';
        break;
      case Filter.MATCHSPLAYED:
        return 'Matchs joués';
        break;
      case Filter.CAPSHIT:
        return 'Caps touchées';
        break;
      case Filter.RATIO:
        return 'Ratio';
        break;
      case Filter.KROEMPTIED:
        return 'Kros bues';
        break;
      case Filter.VICTORYSERIEMAX:
        return 'Serie victoire';
        break;
      case Filter.MAXREVERSE:
        return 'Max reverse';
        break;
      default:
        return 'Points';
    }
  }

  Filter _filter = Filter.POINTS;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Capseur>>.value(
        value: DatabaseService().capseurs,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroundBaseColor,
            shadowColor: Colors.transparent,
            leading: ArrowBackAppBar(),
            title: Text(
              'Classements',
              style: TextStyle(
                  fontFamily: 'PirataOne',
                  fontSize: 30,
                  color: kSecondaryColor),
            ),
            actions: [
              DropdownButton<Filter>(
                value: _filter,
                style: TextStyle(color: Colors.deepPurple),
                onChanged: (Filter newValue) {
                  setState(() {
                    _filter = newValue;
                  });
                },
                items: Filter.values
                    .map<DropdownMenuItem<Filter>>((Filter filter) {
                  return DropdownMenuItem<Filter>(
                    value: filter,
                    child: Text(
                      filterToString(filter),
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          body: Stack(
            children: [
              Background(
                image: Platform.isIOS ? "assets/images/ios_bottle_-15deg.png" : "assets/images/bottle_-15deg.png",
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: RankingList(
                  filter: _filter,
                  onPressed: (Capseur capseur) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (ctxt) => new ProfilePage(
                          capseur: capseur,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
