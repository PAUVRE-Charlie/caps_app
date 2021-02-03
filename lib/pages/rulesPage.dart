import 'package:caps_app/components/arrowBackAppBar.dart';
import 'package:caps_app/components/background.dart';
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
          'Classements',
          style: TextStyle(
              fontFamily: 'PirataOne', fontSize: 30, color: kSecondaryColor),
        ),
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
                    "Chaque joueur se met en face de l’autre. Pour la distance, il suffit que les deux joueurs s'assoient et tendent leurs jambes.",
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
                    "Pour désigner celui qui commence à jouer, vous pouvez vous mettre d'accord ou faire un \"pile ou caps\". C'est comme un pile ou face mais avec une caps.",
                    index: 3),
                TextRules(
                    "Le joueur désigné lance alors sa caps vers son adversaire en essayant de retirer la caps située sur sa bouteille.\nS'il rate, rien ne se passe et c'est au tour de son adversaire de jouer.",
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
                    "Lorsqu’un joueur 1 enlève la caps de son adversaire (joueur 2) celui ci se doit de riposter. Viens alors 2 possibilités. Soit le joueur 2 riposte mais ne fait pas tomber la caps, alors celui ci boit une gorgée. Soit le joueur 2 riposte et fait tomber la cap’s du joueur , c’est alors que nous avons 2 gorgées en jeu. Ainsi c’est au joueur 1 de riposter. Viens alors 2 possibilités (que vous avez compris j’espère). Soit le joueur 1 rate son coup, il boit alors 2 gorgées, soit il réussit et nous passons donc à 3 gorgées mise en jeu. Ainsi de suite jusqu’à ce qu’un joueur, ayant trop de pression, loupe son coup.",
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
                    index: 7),
                TextRules(
                  "je te tiens à signaler à tous les bourrins que le but du jeu n’est pas de faire tomber une caps en jetant sa caps de toute ses forces contre la bouteille (fer contre verre ne compte évidement pas). Un coup est validé si la caps s’est faite éjecter par une caps directement (fer contre fer). Vous entendrez alors ce somptueux son : « POUM! »",
                  textToEmphasize: "ATTENTION : ",
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
                SizedBox(
                  height: 50,
                )
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
