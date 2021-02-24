import 'package:caps_app/components/loading.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/pages/rankingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/capseur.dart';
import '../data.dart';

class RankingList extends StatefulWidget {
  RankingList(
      {Key key,
      this.onPressed(Capseur capseur),
      this.noShowCapseurs,
      this.justThemCapseurs,
      this.filter})
      : super(key: key);

  final Function onPressed;
  final List<Capseur> noShowCapseurs;
  final List<Capseur> justThemCapseurs;
  final Filter filter;

  @override
  _RankingListState createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Function(Capseur, Capseur) getFilter(Filter filter) {
    switch (filter) {
      case Filter.POINTS:
        return ((x, y) => y.points.compareTo(x.points));
        break;
      case Filter.MATCHSWON:
        return ((x, y) => y.matchsWon.compareTo(x.matchsWon));
        break;
      case Filter.MATCHSPLAYED:
        return ((x, y) => y.matchsPlayed.compareTo(x.matchsPlayed));
        break;
      case Filter.CAPSHIT:
        return ((x, y) => y.capsHit.compareTo(x.capsHit));
        break;
      case Filter.RATIO:
        return ((x, y) => y.ratio.compareTo(x.ratio));
        break;
      case Filter.KROEMPTIED:
        return ((x, y) => y.bottlesEmptied.compareTo(x.bottlesEmptied));
        break;
      case Filter.VICTORYSERIEMAX:
        return ((x, y) => y.victorySerieMax.compareTo(x.victorySerieMax));
        break;
      case Filter.MAXREVERSE:
        return ((x, y) => y.maxReverse.compareTo(x.maxReverse));
        break;
      default:
        return ((x, y) => y.points.compareTo(x.points));
    }
  }

  String getValue(Filter filter, Capseur capseur) {
    switch (filter) {
      case Filter.POINTS:
        return capseur.points.round().toString();
        break;
      case Filter.MATCHSWON:
        return capseur.matchsWon.toString();
        break;
      case Filter.MATCHSPLAYED:
        return capseur.matchsPlayed.toString();
        break;
      case Filter.CAPSHIT:
        return capseur.capsHit.toString();
        break;
      case Filter.RATIO:
        return capseur.ratio.toString() + '%';
        break;
      case Filter.KROEMPTIED:
        return capseur.bottlesEmptied.toString();
        break;
      case Filter.VICTORYSERIEMAX:
        return capseur.victorySerieMax.toString();
        break;
      case Filter.MAXREVERSE:
        return capseur.maxReverse.toString();
        break;
      default:
        return capseur.points.round().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);
    var capseurs = Provider.of<List<Capseur>>(context);

    if (capseurs == null) return LoadingWidget();

    if (widget.justThemCapseurs != null) {
      capseurs = widget.justThemCapseurs;
    }

    if (widget.noShowCapseurs != null) {
      capseurs = capseurs.where((capseur) {
        for (Capseur capseur2 in widget.noShowCapseurs) {
          if (capseur2.uid == capseur.uid) return false;
        }
        return true;
      }).toList();
    }

    capseurs.sort(getFilter(widget.filter));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            cursorColor: kSecondaryColor,
            decoration: InputDecoration(
                labelText: "Rechercher",
                labelStyle: TextStyle(color: kSecondaryColor),
                prefixIcon: Icon(
                  Icons.search,
                  color: kSecondaryColor,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kSecondaryColor,
                        style: BorderStyle.solid,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kSecondaryColor,
                        style: BorderStyle.solid,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Capseur capseur = capseurs[index];
                return capseur.username
                        .toLowerCase()
                        .contains(_searchController.value.text.toLowerCase())
                    ? GestureDetector(
                        onTap: () {
                          if (widget.onPressed != null)
                            widget.onPressed(capseur);
                        },
                        child: ListTile(
                          leading: Text((index + 1).toString(),
                              style: TextStyle(fontSize: 20)),
                          title: Text(capseur.username),
                          trailing: Text(getValue(widget.filter, capseur)),
                          tileColor: capseur.uid == user.uid
                              ? kSecondaryColor.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      )
                    : Container();
              },
              itemCount: capseurs.length),
        )
      ],
    );
  }
}
