import 'package:caps_app/components/loading.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/capseur.dart';
import '../data.dart';

class RankingList extends StatefulWidget {
  RankingList(
      {Key key,
      this.onPressed(Capseur capseur),
      this.noShowCapseurs,
      this.justThemCapseurs})
      : super(key: key);

  final Function onPressed;
  final List<Capseur> noShowCapseurs;
  final List<Capseur> justThemCapseurs;

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

    capseurs.sort(((x, y) => y.points.compareTo(x.points)));

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
                          trailing: Text(capseur.points.round().toString()),
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
