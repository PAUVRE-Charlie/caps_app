import 'package:caps_app/components/rankingList.dart';
import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/participant.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../data.dart';
import 'MyTextFormField.dart';
import 'loading.dart';

class CreateTournamentForm extends StatefulWidget {
  CreateTournamentForm({Key key}) : super(key: key);

  @override
  _CreateTournamentFormState createState() => _CreateTournamentFormState();
}

class _CreateTournamentFormState extends State<CreateTournamentForm> {
  String name;
  int numberMaxPlayers;
  int numberPlayersGettingOutOfEachPool;
  int numberPlayersPerPool;
  List<Capseur> capseurs;
  bool randomPool;
  List<String> poolNames;
  String error;

  final _formKey = GlobalKey<FormState>();
  final _poolsCreationKey = GlobalKey<_PoolCreationState>();

  bool loading;

  @override
  void initState() {
    name = '';
    numberMaxPlayers = 0;
    numberPlayersGettingOutOfEachPool = 0;
    numberPlayersPerPool = 0;
    capseurs = new List();
    randomPool = true;
    poolNames = new List();
    error = '';
    loading = false;
    super.initState();
  }

  void _showUserList({Function onSelectCapseur}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamProvider<List<Capseur>>.value(
              value: DatabaseService().capseurs,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: RankingList(
                  onPressed: onSelectCapseur,
                  noShowCapseurs: capseurs,
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Nom du tournoi',
                    validator: (val) {
                      return val.isEmpty ? 'Entre un nom' : null;
                    },
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nombre de joueurs max: "),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        child: MyTextFormField(
                          textInputType: TextInputType.number,
                          validator: (val) {
                            return int.tryParse(val) == null ||
                                    int.parse(val) <= 0
                                ? 'Erreur'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() {
                              numberMaxPlayers =
                                  int.tryParse(val) ?? capseurs.length;
                              if (numberMaxPlayers < capseurs.length)
                                capseurs.removeRange(
                                    numberMaxPlayers, capseurs.length);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (capseurs.length == 0 && numberMaxPlayers > 0)
                    Text(
                      "Ajouter un joueur",
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontFamily: "PirataOne",
                          fontSize: 20),
                    ),
                  Wrap(
                    children: [
                      for (Capseur capseur in capseurs)
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              color: kSecondaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(45)),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "${capseur.firstname} ${capseur.lastname}",
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: kSecondaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      capseurs.remove(capseur);
                                    });
                                  })
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (capseurs.length != numberMaxPlayers)
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: kSecondaryColor,
                      ),
                      onPressed: () {
                        if (capseurs.length < numberMaxPlayers) {
                          _showUserList(onSelectCapseur: (Capseur _opponent) {
                            setState(() {
                              capseurs.add(_opponent);
                            });
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (capseurs.length > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sortants par poule: "),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: MyTextFormField(
                            textInputType: TextInputType.number,
                            validator: (val) {
                              return int.tryParse(val) == null ||
                                      int.parse(val) <= 0 ||
                                      int.parse(val) > capseurs.length
                                  ? 'Erreur'
                                  : null;
                            },
                            onChanged: (val) {
                              setState(() {
                                numberPlayersGettingOutOfEachPool =
                                    int.tryParse(val) ?? 0;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (numberPlayersGettingOutOfEachPool > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Nombre de personnes par poule: "),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: MyTextFormField(
                            textInputType: TextInputType.number,
                            validator: (val) {
                              return int.tryParse(val) == null ||
                                      int.parse(val) <= 1 ||
                                      int.parse(val) <
                                          (numberPlayersGettingOutOfEachPool +
                                              1)
                                  ? 'Erreur'
                                  : null;
                            },
                            onChanged: (val) {
                              setState(() {
                                numberPlayersPerPool = int.tryParse(val) ?? 0;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (numberPlayersPerPool > 0 &&
                      numberPlayersGettingOutOfEachPool > 0 &&
                      capseurs.length > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Poules organisées au hasard: "),
                        Checkbox(
                          value: randomPool,
                          activeColor: kPrimaryColor,
                          onChanged: (val) {
                            setState(() {
                              randomPool = val;
                            });
                          },
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!randomPool)
                    PoolCreation(
                      key: _poolsCreationKey,
                      numberOfPools: numberPlayersPerPool != 0
                          ? (capseurs.length / numberPlayersPerPool).ceil()
                          : 0,
                      capseurs: capseurs,
                      maxPlayersPerPool: numberPlayersPerPool,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        List<Pool> _pools =
                            _poolsCreationKey.currentState.pools;

                        Uuid uuid = Uuid();
                        setState(() {
                          loading = true;
                        });
                        String tournamentUid = uuid.v4();
                        await DatabaseService().updateTournamentData(
                            tournamentUid,
                            name,
                            numberPlayersGettingOutOfEachPool);

                        for (Pool pool in _pools) {
                          String poolUid = uuid.v4();
                          await DatabaseService().updatePoolData(
                              poolUid, tournamentUid, pool.name);
                          for (Participant participant in pool.participants) {
                            await DatabaseService()
                                .updateCapseursInTournamentsData(tournamentUid,
                                    poolUid, participant.capseur.uid);
                          }
                        }
                        setState(() {
                          loading = false;
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    color: kPrimaryColor,
                    child: Text('Créer', style: TextStyle(color: kWhiteColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          );
  }
}

class PoolCreation extends StatefulWidget {
  const PoolCreation(
      {Key key,
      @required this.numberOfPools,
      @required this.capseurs,
      @required this.maxPlayersPerPool})
      : super(key: key);

  final int numberOfPools;
  final int maxPlayersPerPool;
  final List<Capseur> capseurs;

  @override
  _PoolCreationState createState() => _PoolCreationState();
}

class _PoolCreationState extends State<PoolCreation> {
  List<Pool> pools;

  @override
  void initState() {
    pools = new List();
    for (int i = 0; i < widget.numberOfPools; i++) {
      pools.add(new Pool("", "", "Poule ${i + 1}"));
    }
    super.initState();
  }

  void _showUserList({
    Function onSelectCapseur,
    List<Capseur> noShowCapseurs,
    List<Capseur> justThemCapseur,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamProvider<List<Capseur>>.value(
              value: DatabaseService().capseurs,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: RankingList(
                  onPressed: onSelectCapseur,
                  noShowCapseurs: noShowCapseurs,
                  justThemCapseurs: justThemCapseur,
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    while (widget.numberOfPools > pools.length) {
      pools.add(new Pool("", "", "Poule ${pools.length}"));
    }

    if (widget.numberOfPools < pools.length) {
      pools.removeRange(widget.numberOfPools, pools.length);
    }

    return Column(
      children: [
        for (Pool pool in pools) ...{
          Container(
            decoration: BoxDecoration(
                color: kSecondaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MyTextFormField(
                    textInputType: TextInputType.text,
                    initialValue: pool.name,
                    validator: (val) {
                      return val.isEmpty ? 'Erreur' : null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pool.setName(val);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (pool.participants.length == 0 &&
                    widget.maxPlayersPerPool > 0)
                  Text(
                    "Ajouter un joueur",
                    style: TextStyle(
                        color: kSecondaryColor,
                        fontFamily: "PirataOne",
                        fontSize: 20),
                  ),
                Wrap(
                  children: [
                    for (Participant participant in pool.participants)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(45)),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "${participant.capseur.firstname} ${participant.capseur.lastname}",
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: kSecondaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    pool.removeParticipant(participant);
                                  });
                                })
                          ],
                        ),
                      ),
                  ],
                ),
                if (pool.participants.length != widget.maxPlayersPerPool)
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: kSecondaryColor,
                    ),
                    onPressed: () {
                      if (pool.participants.length !=
                          widget.maxPlayersPerPool) {
                        List<Capseur> noShowList = pool.participants
                            .map((participant) => participant.capseur)
                            .toList();

                        for (Pool pool in pools) {
                          noShowList.addAll(pool.participants
                              .map((participant) => participant.capseur));
                        }

                        _showUserList(
                            noShowCapseurs: noShowList,
                            justThemCapseur: widget.capseurs,
                            onSelectCapseur: (Capseur _capseur) {
                              setState(() {
                                pool.addParticipant(
                                    new Participant.initial(_capseur));
                              });
                              Navigator.of(context).pop();
                            });
                      }
                    },
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        },
      ],
    );
  }
}
