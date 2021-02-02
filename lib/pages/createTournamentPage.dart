import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:caps_app/components/createTournamentForm.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class CreateTournamentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        leading: ArrowBackAppBar(),
        title: Text(
          'Tournois',
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
        ),
      ),
      body: Stack(
        children: [
          Background(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CreateTournamentForm(),
          )
        ],
      ),
    );
  }
}
