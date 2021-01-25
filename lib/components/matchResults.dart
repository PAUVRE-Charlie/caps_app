import 'package:caps_app/data.dart';
import 'package:caps_app/models/basicUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchResults extends StatefulWidget {
  MatchResults({Key key}) : super(key: key);

  @override
  _MatchResultsState createState() => _MatchResultsState();
}

class _MatchResultsState extends State<MatchResults> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pierre Schmutz',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w300)),
                Text(' - '),
                Text('Charlie Pauvré',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '15' + ' - ' + '6',
              style: TextStyle(fontFamily: 'PirataOne', fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
