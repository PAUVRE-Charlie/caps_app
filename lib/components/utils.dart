import 'package:flutter/material.dart';
import 'dart:io';

Future<void> displayDisclamer(context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Attention"),
            content: SingleChildScrollView(
              child: Text(
                "L'abus d'alcool est dangereux pour la santé. En poursuivant vous confirmez être responsable des éventuelles conséquences que pourrait engendrer l'utilisation de Caps Beer Game. Sachez que vous n'êtes en aucun cas forcé à boire de l'alcool et nous rappelons que ce jeu peut bien évidemment se jouer sans alcool.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "NotoSansJP"),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("FERMER"),
                onPressed: () => exit(0),
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
