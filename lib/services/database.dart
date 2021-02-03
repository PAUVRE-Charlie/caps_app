import 'package:caps_app/models/capseur.dart';
import 'package:caps_app/models/matchEnded.dart';
import 'package:caps_app/models/matchWaitingToBeValidated.dart';
import 'package:caps_app/models/matchsOfTournament.dart';
import 'package:caps_app/models/pool.dart';
import 'package:caps_app/models/tournamentInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference capseursCollection =
      FirebaseFirestore.instance.collection('capseurs');

  final CollectionReference matchsCollection =
      FirebaseFirestore.instance.collection('matchs');

  final CollectionReference matchsWaitingToBeValidatedCollection =
      FirebaseFirestore.instance.collection('matchsWaitingToBeValidated');

  final CollectionReference matchsOfTournamentsCollection =
      FirebaseFirestore.instance.collection('matchsOfTournaments');

  final CollectionReference tournamentsCollection =
      FirebaseFirestore.instance.collection('tournaments');

  final CollectionReference poolsCollection =
      FirebaseFirestore.instance.collection('pools');

  final CollectionReference capseursInTournamentsCollection =
      FirebaseFirestore.instance.collection('capseursInTournaments');

  /* 
        ################################################################

              USERDATA (update data for the current user)

        ################################################################
  */

  Capseur _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return Capseur(
      snapshot.data()['firstname'] ?? '',
      snapshot.data()['lastname'] ?? '',
      snapshot.data()['matchsPlayed'] ?? '',
      snapshot.data()['matchsWon'] ?? '',
      snapshot.data()['capsHit'] ?? '',
      snapshot.data()['capsThrow'] ?? '',
      snapshot.data()['bottlesEmptied'] ?? '',
      uid,
      snapshot.data()['points'] ?? '',
    );
  }

  Stream<Capseur> get userData {
    return capseursCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userDataFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              CAPSEURS

        ################################################################
  */

  Future updateCapseurData(
      String _uid,
      String firstname,
      String lastname,
      int matchsPlayed,
      int matchsWon,
      int capsHit,
      int capsThrow,
      int bottlesEmptied,
      double points) async {
    return await capseursCollection.doc(_uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'matchsPlayed': matchsPlayed,
      'matchsWon': matchsWon,
      'capsHit': capsHit,
      'capsThrow': capsThrow,
      'bottlesEmptied': bottlesEmptied,
      'points': points,
    });
  }

  // Capseur list from snapshot
  List<Capseur> _capseurListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Capseur(
        doc.data()['firstname'] ?? '',
        doc.data()['lastname'] ?? '',
        doc.data()['matchsPlayed'] ?? '',
        doc.data()['matchsWon'] ?? '',
        doc.data()['capsHit'] ?? '',
        doc.data()['capsThrow'] ?? '',
        doc.data()['bottlesEmptied'] ?? '',
        doc.id ?? '',
        doc.data()['points'] ?? '',
      );
    }).toList();
  }

  Stream<List<Capseur>> get capseurs {
    return capseursCollection
        .snapshots()
        .map((snapshot) => _capseurListFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              MATCHS

        ################################################################
  */

  Future updateMatchData(String uidCapseur1, String uidCapseur2,
      int scorePlayer1, int scorePlayer2) async {
    return await matchsCollection.doc().set({
      'capseur1': uidCapseur1,
      'capseur2': uidCapseur2,
      'date': Timestamp.now(),
      'scorePlayer1': scorePlayer1,
      'scorePlayer2': scorePlayer2,
    });
  }

  List<MatchEnded> _matchListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MatchEnded(
        doc.id,
        doc.data()['capseur1'] ?? '',
        doc.data()['capseur2'] ?? '',
        doc.data()['date'] ?? Timestamp.now(),
        doc.data()['scorePlayer1'] ?? 0,
        doc.data()['scorePlayer2'] ?? 0,
      );
    }).toList();
  }

  Stream<List<MatchEnded>> get matchs {
    return matchsCollection
        .snapshots()
        .map((snapshot) => _matchListFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              MATCHS WAITING TO BE VALIDATED

        ################################################################
  */

  Future updateMatchWaitingToBeValidatedData(
      String uidCapseur1,
      String uidCapseur2,
      int scorePlayer1,
      int scorePlayer2,
      int pointsRequired,
      int pointsPerBottle,
      int capsHitPlayer1,
      int capsThrowPlayer1,
      int capsHitPlayer2,
      int capsThrowPlayer2,
      ) async {
    return await matchsWaitingToBeValidatedCollection.doc().set({
      'capseur1': uidCapseur1,
      'capseur2': uidCapseur2,
      'date': Timestamp.now(),
      'scorePlayer1': scorePlayer1,
      'scorePlayer2': scorePlayer2,
      'pointsRequired': pointsRequired,
      'pointsPerBottle': pointsPerBottle,
      'capsHitPlayer1': capsHitPlayer1,
      'capsThrowPlayer1': capsThrowPlayer1,
      'capsHitPlayer2': capsHitPlayer2,
      'capsThrowPlayer2': capsThrowPlayer2,
    });
  }

  List<MatchWaitingToBeValidated> _matchsWaitingToBeValidatedListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MatchWaitingToBeValidated(
        doc.id,
        doc.data()['capseur1'] ?? '',
        doc.data()['capseur2'] ?? '',
        doc.data()['date'] ?? Timestamp.now(),
        doc.data()['scorePlayer1'] ?? 0,
        doc.data()['scorePlayer2'] ?? 0,
        doc.data()['pointsRequired'] ?? 0,
        doc.data()['pointsPerBottle'] ?? 0,
        doc.data()['capsHitPlayer1'] ?? 0,
        doc.data()['capsThrowPlayer1'] ?? 0,
        doc.data()['capsHitPlayer2'] ?? 0,
        doc.data()['capsThrowPlayer2'] ?? 0,
      );
    }).toList();
  }

  Stream<List<MatchWaitingToBeValidated>> get matchsWaitingToBeValidated {
    return matchsWaitingToBeValidatedCollection.snapshots().map(
        (snapshot) => _matchsWaitingToBeValidatedListFromSnapshot(snapshot));
  }

  void deleteMatchWaitingToBeValidated(String _uid) async {
    return await matchsWaitingToBeValidatedCollection.doc(_uid).delete();
  }

  /* 
        ################################################################

              MATCHS OF TOURNAMENTS

        ################################################################
  */

  Future updateMatchOfTournamentData(String matchUid, String tournamentUid,
      {String poolUid, int finalBoardPosition}) async {
    return await matchsCollection.doc().set({
      'matchUid': matchUid,
      'tournamentUid': tournamentUid,
      'poolUid': poolUid,
      'finalBoardPosition': finalBoardPosition
    });
  }

  List<MatchOfTournament> _matchsOfTournamentsListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MatchOfTournament(
          doc.data()['matchUid'],
          doc.data()['tournamentUid'] ?? '',
          doc.data()['poolUid'] ?? '',
          doc.data()['finalBoardPosition'] ?? 0);
    }).toList();
  }

  Stream<List<MatchOfTournament>> get matchsOfTournaments {
    return matchsOfTournamentsCollection
        .snapshots()
        .map((snapshot) => _matchsOfTournamentsListFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              TOURNAMENTS

        ################################################################
  */

  Future updateTournamentData(
      String _uid, String name, int numberPlayerGettingOutOfEachPool) async {
    return await tournamentsCollection.doc(_uid).set({
      'name': name,
      'numberPlayerGettingOutOfEachPool': numberPlayerGettingOutOfEachPool
    });
  }

  List<TournamentInfo> _tournamentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TournamentInfo(doc.id, doc.data()['name'] ?? '',
          doc.data()['numberPlayersGettingOutOfEachPool'] ?? 0);
    }).toList();
  }

  Stream<List<TournamentInfo>> get tournaments {
    return tournamentsCollection
        .snapshots()
        .map((snapshot) => _tournamentListFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              POOLS

        ################################################################
  */

  Future updatePoolData(String _uid, String tournamentUid, String name) async {
    return await poolsCollection
        .doc(_uid)
        .set({'tournamentUid': tournamentUid, 'name': name});
  }

  List<Pool> _poolListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Pool(
          doc.id, doc.data()['tournamentUid'] ?? '', doc.data()['name'] ?? '');
    }).toList();
  }

  Stream<List<Pool>> get pools {
    return poolsCollection
        .snapshots()
        .map((snapshot) => _poolListFromSnapshot(snapshot));
  }

  /* 
        ################################################################

              CAPSEURS IN TOURNAMENTS

        ################################################################
  */

  Future updateCapseursInTournamentsData(
      String tournamentUid, String poolUid, String capseurUid) async {
    return await capseursInTournamentsCollection.doc().set({
      'tournamentUid': tournamentUid,
      'poolUid': poolUid,
      'capseurUid': capseurUid
    });
  }

  Map<String, Map<String, String>> _capseursInTournamentsMapFromSnapshot(
      QuerySnapshot snapshot) {
    Map<String, Map<String, String>> listOfPoolsAndCapseursInTournaments =
        new Map();
    // tournamentUid: poolUid: capseurUid
    snapshot.docs.forEach((doc) {
      Map<String, String> tournamentMap =
          listOfPoolsAndCapseursInTournaments[doc.data()['tournamentUid']] ??
              new Map();
      tournamentMap[doc.data()['capseurUid']] = doc.data()['poolUid'];
      listOfPoolsAndCapseursInTournaments[doc.data()['tournamentUid']] =
          tournamentMap;
    });
    return listOfPoolsAndCapseursInTournaments;
  }

  Stream<Map<String, Map<String, String>>> get capseursInTournaments {
    return capseursInTournamentsCollection
        .snapshots()
        .map((snapshot) => _capseursInTournamentsMapFromSnapshot(snapshot));
  }
}
