import 'package:caps_app/components/loading.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/capseur.dart';
import '../data.dart';

class RankingList extends StatefulWidget {
  RankingList({Key key, this.onPressed(Capseur capseur)}) : super(key: key);

  final Function onPressed;

  @override
  _RankingListState createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BasicUser>(context);
    final capseurs = Provider.of<List<Capseur>>(context);

    if (capseurs == null) return LoadingWidget();

    capseurs.sort(((x, y) => y.points.compareTo(x.points)));

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Capseur capseur = capseurs[index];
          return GestureDetector(
            onTap: () {
              if (widget.onPressed != null) widget.onPressed(capseur);
            },
            child: ListTile(
              leading: Text((index + 1).toString(), style: TextStyle(fontSize: 20)),
              title: Text(capseur.firstname),
              trailing: Text(capseur.points.round().toString()),
              tileColor: capseur.uid == user.uid
                  ? kPrimaryColor.withOpacity(0.3)
                  : Colors.transparent,
            ),
          );
        },
        itemCount: capseurs.length);
  }
}
