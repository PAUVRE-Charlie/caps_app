import 'package:caps_app/components/loading.dart';
import 'package:caps_app/data.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/game.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    if (widget.tournament.pools.isEmpty)
      return Center(
          child: Text(
        "Pas de poules dans ce tournoi",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'PirataOne', fontSize: 35, color: Colors.black),
      ));

    final user = Provider.of<BasicUser>(context);

    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: Colors.black.withOpacity(0.3),
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Colors.black),
      child: ListView.builder(
        itemCount: widget.tournament.pools.length,
        itemBuilder: (BuildContext context, int index) {
          Pool pool = widget.tournament.sortedPools[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            decoration: BoxDecoration(
              color: null,
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: index != 0
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent)),
            ),
            child: ExpansionTile(
              title: Text(
                pool.name,
                style: TextStyle(
                    color: pool.isInThisPool(user.uid)
                        ? kPrimaryColor
                        : Colors.black),
              ),
              initiallyExpanded: true,
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
                for (Participant participant in pool.rankedPartipant)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "${participant.getCapseur(widget.capseurs).username}",
                          style: TextStyle(
                              fontSize: 16,
                              color: participant.capseurUid == user.uid
                                  ? kPrimaryColor
                                  : null),
                        ),
                      ),
                      Row(
                        children: [
                          pool.canPlay(user.uid, participant.capseurUid,
                                  widget.tournament.matchs)
                              ? PlayButton(
                                  tournamentUid: pool.tournamentUid,
                                  poolUid: pool.uid,
                                  capseur: widget.capseurs.firstWhere(
                                      (capseur) => capseur.uid == user.uid),
                                  opponent: widget.capseurs.firstWhere(
                                      (capseur) =>
                                          capseur.uid ==
                                          participant.capseurUid),
                                )
                              : Container(),
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
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton(
      {Key key,
      @required this.tournamentUid,
      @required this.poolUid,
      @required this.capseur,
      @required this.opponent})
      : super(key: key);

  final String tournamentUid;
  final String poolUid;
  final Capseur capseur;
  final Capseur opponent;

  @override
  Widget build(BuildContext context) {
    final matchsWaitingToBeValidated =
        Provider.of<List<MatchWaitingToBeValidated>>(context);

    if (matchsWaitingToBeValidated == null) return LoadingWidget();

    bool isAlreadyPlayedFunction() {
      for (MatchWaitingToBeValidated match in matchsWaitingToBeValidated) {
        if (match.poolUid == poolUid &&
            match.isOpposing(capseur.uid, opponent.uid)) return true;
      }
      return false;
    }

    bool isAlreadyPlayed = isAlreadyPlayedFunction();

    return TextButton(
      child: Text(
        isAlreadyPlayed ? "A valider..." : "Jouer",
      ),
      onPressed: !isAlreadyPlayed
          ? () {
              Game.startMatchOfTournament(
                context,
                "Match",
                capseur,
                tournamentUid,
                poolUid: poolUid,
                capseur2: opponent,
              );
            }
          : null,
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
