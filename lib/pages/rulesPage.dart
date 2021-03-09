import 'dart:ui';

import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundBaseColor,
        shadowColor: Colors.transparent,
        leading: ArrowBackAppBar(),
        title: Text(
          'Règles',
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
        ),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(15.0),
            child: Image(image: AssetImage("assets/images/united-kingdom.png")),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/rulesenglish');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Background(
            image: "assets/images/bottle_32deg.png",
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                TextRules(
                    "Les 2 joueurs s'installent par terre l'un en face de l’autre. Pour la distance, il suffit que les deux joueurs s'assoient et tendent leurs jambes.",
                    index: 1),
                TextRules(
                    "Chaque joueur décapsule sa bouteille de bière, la pose entre ses jambes, et pose la capsule sur la bouteille, à l'envers.",
                    index: 2),
                Image.asset(
                  "assets/images/match_bottle_wcaps.png",
                  height: MediaQuery.of(context).size.height / 7,
                ),
                TextRules(
                    "pour jouer, il faut au moins une caps en plus de celle des deux bouteilles.",
                    textToEmphasize: "Note: "),
                TextRules(
                    "Pour désigner celui qui commence à jouer, un tirage aléatoire \"pile ou caps\" est réalisé au début d'un match",
                    index: 3),
                TextRules(
                    "Le joueur désigné lance alors sa caps vers son adversaire en essayant de toucher la caps située sur sa bouteille.\nS'il rate, rien ne se passe et c'est au tour de son adversaire de jouer.",
                    index: 4),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/lancerCaps.gif",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                TextRules(
                    "Lorsqu’un joueur 1 enlève la caps de son adversaire (joueur 2) celui ci se doit de riposter. Viens alors 2 possibilités. Soit le joueur 2 riposte mais ne fait pas tomber la caps, alors celui ci boit une gorgée. Soit le joueur 2 riposte et fait tomber la cap’s du joueur, c’est alors que nous avons 2 gorgées en jeu. Ainsi c’est au joueur 1 de riposter. Viens alors 2 possibilités (que vous avez compris j’espère). Soit le joueur 1 rate son coup, il boit alors 2 gorgées, soit il réussit et nous passons donc à 3 gorgées mise en jeu. Ainsi de suite jusqu’à ce qu’un joueur, ayant trop de pression, loupe son coup.",
                    index: 5),
                TextRules(
                  "lorsque je dis \"une gorgée\" je veux dire une fois le nombre de gorgée à boire. Par exemple, s'il a été fixé que une bière valait 4 points, une \"gorgée\" correspond alors à un quart de la bouteille. Le nombre de points par bouteille ainsi que le nombre de bouteilles à boire sont à fixer avant le début de la partie.",
                  textToEmphasize: "ATTENTION : ",
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/drinkBeer.gif",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                TextRules(
                    "Pour chaque \"gorgée\" bue par un joueur, son adversaire marque un point. Une fois qu'un joueur a fini de boire toutes ses bouteilles il a perdu.",
                    index: 6),
                TextRules(
                  "je tiens à signaler à tous les bourrins que le but du jeu n’est pas de faire tomber une caps en jetant sa caps de toute ses forces contre la bouteille (fer contre verre ne compte évidemment pas). Un coup est validé si la caps s’est faite éjectée par une caps directement (fer contre fer). Vous entendrez alors ce somptueux son : « POUM! »",
                  textToEmphasize: "ATTENTION : ",
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Le classement comment ça marche ?",
                  style: TextStyle(
                      fontFamily: "PirataOne",
                      fontSize: 25,
                      color: kPrimaryColor),
                ),
                TextRules(
                  "\nL'algorithme a été établi de la manière suivante.\nChaque nouveau joueur commence initialement avec 100 points. Si vous gagnez un match vous gagnez des points, si vous perdez, vous en perdez, simple.\nMais bien sûr, si vous gagnez contre un joueur mieux classé que vous, vous marquerez plus de points (« perf ») que si vous gagnez un joueur moins bien classé que vous. A contrario si vous perdez contre un joueur moins bien classé que vous, vous perderez plus de points (« contre-perf ») que si vous perdez contre un joueur mieux classé que vous.\nNotez que pour récompenser les joueurs jouant beaucoup, lors d'un match le perdant perds 80% des points gagnés par le gagnant.\nExemple : prenons 2 joueurs avec le même nombre de points qui font un match en 16 points. Le gagnant gagnera 5 points et le perdant perdra 4 points. Ainsi, le nombre de point total distribué augmentera avec le nombre de matchs joués. Enfin si le match se joue en 4 il y aura moins de points attribués (coefficient 0.25) qu'un match en 16 (coefficient 1) ou encore plus en 32 (coefficient 2) pour des raisons de fiabilité.\n Enfin, un coefficient de buvabilité entre aussi en jeu. Il valorise les matchs avec un faible nombre de points par kro et diminue l'importance d'un match avec un grand nombre de points par kro, le coefficient 1 étant pour 4 points par kro.",
                ),
                TextRules(
                  "\nGain points = Gain de points en fonction de l'écart * coefficient de fiabilité * coefficient de buvabilité",
                  textToEmphasize : "Victoire : ",
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextRules(
                    "\nPerte points = Gain points victoire * 0.8",
                    textToEmphasize : "Défaite : ",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/courbesGains.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/coeffFiabilite.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/coeffBuvabilite.png",
                      width: MediaQuery.of(context).size.width * 5 / 6,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Amusez-vous bien !",
                  style: TextStyle(
                      fontFamily: "PirataOne",
                      fontSize: 25,
                      color: kPrimaryColor),
                ),
                TextRules(
                    "\n(Nous déclinons toute responsabilité en cas de problèmes liés à votre consommation d'alcool)"),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Créateurs de l'application: Charlie PAUVRÉ & Pierre SCHMUTZ",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TextRules extends StatelessWidget {
  const TextRules(this.text, {Key key, this.index, this.textToEmphasize})
      : super(key: key);

  final String text;
  final String textToEmphasize;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: textToEmphasize == null
          ? RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: (index != null ? index.toString() + ". " : ""),
                  style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                      fontFamily: "PirataOne"),
                  children: [
                    TextSpan(
                      text: text,
                      style: TextStyle(
                          color: Colors.black, fontFamily: "NotoSansJP"),
                    )
                  ]))
          : RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: (textToEmphasize),
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontFamily: "PirataOne"),
                  children: [
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "NotoSansJP",
                        fontSize: 15,
                      ),
                    )
                  ])),
    );
  }
}
