import 'package:caps_app/data.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';

class PoolsView extends StatefulWidget {
  PoolsView({Key key, @required this.tournament, this.capseurs})
      : super(key: key);

  final Tournament tournament;
  final List<Capseur> capseurs;

  @override
  _PoolsViewState createState() => _PoolsViewState();
}

class _PoolsViewState extends State<PoolsView> {
  @override
  Widget build(BuildContext context) {
    if (widget.tournament.pools.isEmpty) return Text('Pas de poules');

    return ListView.builder(
      itemCount: widget.tournament.pools.length,
      itemBuilder: (BuildContext context, int index) {
        Pool pool = widget.tournament.pools[index];
        return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: index % 3 == 0
                  ? kPrimaryColor.withOpacity(0.3)
                  : index % 3 == 1
                      ? kSecondaryColor.withOpacity(0.3)
                      : null,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: ExpansionTile(
            title: Text(pool.name),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Wrap(
                    children: [
                      StatsText(text: "V", fontSize: 17),
                      StatsText(text: "D", fontSize: 17),
                      StatsText(text: "Dif", fontSize: 17),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              for (Participant participant in pool.participants)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "${participant.getCapseur(widget.capseurs).username}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        StatsText(
                          text: participant.winsInPool.toString(),
                          fontSize: 20,
                        ),
                        StatsText(
                          text: participant.defeatsInPool.toString(),
                          fontSize: 20,
                        ),
                        StatsText(
                          text: participant.capsAverage.toString(),
                          fontSize: 20,
                        ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}

class StatsText extends StatelessWidget {
  const StatsText({Key key, this.text, this.fontSize}) : super(key: key);

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
